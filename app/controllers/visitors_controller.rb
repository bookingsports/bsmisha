class VisitorsController < ApplicationController
  def index
    @q = Stadium.ransack(params[:q])

    @stadiums = @q.result(distinct: true)
                  .includes(:areas, :category).active.where('areas_count > 0')

    @stadiums_popular = Stadium.active.order(:paid_events_counter).reverse[0..2]
    @coaches_popular = Coach.all.sort_by {|c| Event.where(coach_id: c.id).count }.reverse[0..2]

    set_markers @stadiums
  end
end
