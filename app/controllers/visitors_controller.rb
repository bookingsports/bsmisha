class VisitorsController < ApplicationController
  def index
    @q = Stadium.ransack(params[:q])

    @stadiums = @q.result(distinct: true)
                  .includes(:courts, :pictures)
                  .active

    set_markers
  end

  private

    def set_markers
      gon.markers = JSON.parse(VisitorsController.new.render_to_string(
          locals: { stadiums: @stadiums },
          template: 'stadiums/_stadiums',
          formats: 'json',
          layout: false))
    end
end
