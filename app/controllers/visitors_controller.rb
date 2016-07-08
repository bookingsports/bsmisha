class VisitorsController < ApplicationController
  def index
    @q = Stadium.ransack(params[:q])

    @stadiums = @q.result(distinct: true)
                  .includes(:areas, :pictures).active

    @stadiums_popular = Stadium.active.sort_by {|s| Event.paid_or_confirmed.where(area: s.area_ids).count }.reverse[0..2]
    @coaches_popular = Coach.all.sort_by {|c| Event.paid_or_confirmed.where(coach_id: c.id).count }.reverse[0..2]

    set_markers @stadiums
  end
end
