class Coach::EventsController < EventsController
  def index
    @coach_court = CoachesCourt.find params[:coaches_court_id]
    @events = @coach_court.events.paid_or_owned_by(current_user)

    respond_to do |format|
      format.json { render json: @events }
    end
  end

  def event_params
    params.require(:event).permit(Event.strong_params).merge(additional_params)
  end

  def additional_params
    {
      product_ids: [Coach.friendly.find(params[:coach_id]).id, CoachesCourt.find(params[:coaches_court_id]).court.id]
    }
  end
end
