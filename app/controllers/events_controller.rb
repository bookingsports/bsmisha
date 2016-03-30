# == Schema Information
#
# Table name: events
#
#  id                   :integer          not null, primary key
#  start                :datetime
#  stop                 :datetime
#  description          :string
#  coach_id             :integer
#  area_id              :integer
#  order_id             :integer
#  user_id              :integer
#  recurrence_rule      :string
#  recurrence_exception :string
#  recurrence_id        :integer
#  is_all_day           :boolean
#  status               :integer          default(0)
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#

class EventsController < ApplicationController
  respond_to :json, :html
  before_filter :authenticate_user!, except: [:index, :parents_events]

  def index
    if current_user.present? && current_user.type == "StadiumUser"
      @events = current_user.stadium_events.active.paid.where(area: current_product)
    elsif current_user.present? && params[:area_id].present?
      @events = current_user.events.active.where(area: current_product)
    elsif current_user.present?
      @events = current_user.events.active
    else
      @events = Event.active.where(area: current_product)
    end
    respond_with @events
  end

  def parents_events
    if params[:scope] == "stadium"
      stadium = Stadium.friendly.find(params[:stadium_id])
      @events = stadium.areas.flat_map {|area| Event.where(area: area)}
    end

    render :index
  end

  def private
    @events = current_user.events

    respond_with @events do |format|
      # format.html { render layout:  }
    end
  end

  def create
    @event = current_user.events.create event_params.delete_if {|k,v| v.empty? }
    @event.area = current_product
    @event.save!
  end

  def update
    if current_user.present? && current_user.type == "StadiumUser"
      @event = current_user.stadium_events.find(params[:id])
    else
      @event = current_user.events.find(params[:id])
    end
    @event.update event_params
    #if @event.update event_params
      respond_with @event
    #else
    #  render json: { error: 'Transfer error' }
    #end
  end

  def edit
  end

  def show
    @event = Event.find(params[:id])

    respond_with @event
  end

  def destroy
    event = Event.find(params[:id])
    event.destroy

    respond_to do |format|
      format.html {redirect_to my_events_path, notice: "Успешно удален." }
      format.json {respond_with event}
    end
  end

  def ticket
    @event = Event.find(params[:id])

    pdf = TicketPdf.new(@event, view_context)
    send_data pdf.render, filename: "ticket_#{@event.id}.pdf", type: "application/pdf"
  end

  private

    def find_event

    end

    def event_params
      params.require(:event).permit(
        :id, :start, :stop, :area_id, :user_id, :coach_id, :is_all_day, :owned, :status,
        :recurrence_rule, :recurrence_id, :recurrence_exception,
        stadium_service_ids: []
      )
    end

    def current_product
      Area.where(slug: params[:area_id].to_s).last
    end
end
