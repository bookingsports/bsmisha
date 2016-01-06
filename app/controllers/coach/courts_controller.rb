class Coach::CourtsController < CoachesController
  layout "coaches_courts"

  def show
    @court = CoachesCourt.find params[:id]
  end
end
