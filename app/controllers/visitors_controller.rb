class VisitorsController < ApplicationController
  def index
    @q = Stadium.ransack(params[:q])

    @stadiums = @q.result(distinct: true)
                  .includes(:category).active.where('areas_count > 0')

    @stadiums_popular = Stadium.active.order(paid_events_counter: :desc).reverse[0..2]
    @coaches_popular = Coach.all.includes(:user).order(paid_events_counter: :desc).reverse[0..2]

    set_markers @stadiums
  end
end
