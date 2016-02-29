class Coach::AreasController < CoachesController
  layout "coaches_areas"

  def show
    @area = CoachesArea.find params[:id]
  end
end
