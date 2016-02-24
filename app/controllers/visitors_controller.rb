class VisitorsController < ApplicationController
  def index
    @q = Stadium.ransack(params[:q])

    @stadiums = @q.result(distinct: true)
                  .includes(:courts, :pictures)
                  .active

    set_markers @stadiums
  end
end
