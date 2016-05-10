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
#  price                :float
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
    if params[:area_id].present? && current_user.present? && current_user.type == "CoachUser"
      @events = Event.paid_or_confirmed.where(area: current_product).where(coach: current_user.coach).union(current_user.events.where(area: current_product))
    elsif params[:area_id].present? && current_user.present?
      @events = Event.paid_or_confirmed.where(area: current_product).union(current_user.events.where(area: current_product))
    elsif current_user.present? && current_user.type == "CoachUser"
      @events = Event.paid_or_confirmed.where(coach: current_user.coach).union(current_user.events)
    elsif current_user.present? && current_user.type == "StadiumUser"
      @events = current_user.stadium_events.union(current_user.events)
    elsif current_user.present?
      @events = Event.paid_or_confirmed.union(current_user.events)
    elsif params[:area_id].present?
      @events = Event.paid_or_confirmed.where(area: current_product)
    else
      @events = Event.paid_or_confirmed
    end
    respond_with @events
  end

  def parents_events
    if params[:scope] == "stadium"
      stadium = Stadium.friendly.find(params[:stadium_id])
      if current_user.present?
        @events = stadium.areas.flat_map {|area| current_user.events.where(area: area)}
      else
        @events = []
      end
    end

    render :index
  end

  def one_day
    @stadium = params[:stadium].present? ? params[:stadium] : Stadium.active.map(&:id)
    @day = params["day(1i)"].present? ? DateTime.new(params["day(1i)"].to_i, params["day(2i)"].to_i, params["day(3i)"].to_i) : DateTime.now

    @events = Event.paid_or_confirmed.joins(:area).where(areas: {stadium_id: @stadium}).where(start: @day.beginning_of_day..@day.end_of_day)
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
    if current_user.type == "StadiumUser" && current_user.stadium.areas.include?(@event.area)
      @event.status = :locked
    end
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

  def for_sale
    @my_events = current_user.present? ? current_user.events.paid.future.where.not(status: Event.statuses[:for_sale]) : []
    @events = Event.paid.for_sale
  end

  def show
    @event = Event.find(params[:id])

    respond_with @event
  end

  def buy
    @event = Event.find(params[:id])
    transaction = ActiveRecord::Base.transaction do
      current_user.wallet.withdraw! @event.price
      @event.user.wallet.deposit! @event.price
      @event.update user: current_user, status: :unconfirmed
    end
    redirect_to for_sale_events_path, notice: "Заказ успешно куплен."
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
      Area.friendly.find params[:area_id]
    end
end
