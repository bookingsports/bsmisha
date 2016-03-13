class Coach::EventsController < EventsController
  def index
    @coach_area = CoachesArea.find params[:coaches_area_id]
    @events = @coach_area.events.paid_or_owned_by(current_user)

    respond_to do |format|
      format.json { render json: @events }
    end
  end

  def event_params
    params.require(:event).permit(Event.strong_params).merge(additional_params)
  end

  def additional_params
    {
      product_ids: [Coach.friendly.find(params[:coach_id]).id, CoachesArea.find(params[:coaches_area_id]).area.id]
    }
  end
end
