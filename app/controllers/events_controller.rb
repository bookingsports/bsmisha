# == Schema Information
#
# Table name: events
#
#  id                   :integer          not null, primary key
#  start                :datetime
#  end                  :datetime
#  description          :string
#  product_id           :integer
#  order_id             :integer
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#  recurrence_rule      :string
#  recurrence_exception :string
#  recurrence_id        :integer
#  is_all_day           :boolean
#  user_id              :integer
#

class EventsController < ApplicationController
  respond_to :json, :html
  before_filter :authenticate_user!, except: [:index, :parents_events]

  def index
    logger.debug { current_products.inspect }

    @events = Event.of_products(current_products).paid_or_owned_by(current_user)
    respond_with @events
  end

  def parents_events
    if params[:scope] == "stadium"
      stadium = Stadium.friendly.find(params[:stadium_id])
      @events = stadium.courts.flat_map {|court| Event.of_products(court)}
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
    @event = current_user.new_event event_params.delete_if {|k,v| v.empty? }
    @event.products = current_products
    @event.save!
  end

  def update
    @event = current_user.events.find(params[:id])
    service = Event::TransferService.new(@event, event_params)
    if service.perform
      respond_with @event
    else
      render json: { error: "Transfer error" }
    end
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

    redirect_to my_events_path, notice: "Успешно удален."
  end

  private

    def find_event

    end

    def event_params
      params.require(:event).permit(
        :id, :start, :end, :user_id, :is_all_day, :owned,
        :recurrence_rule, :recurrence_id, :recurrence_exception,
        product_service_ids: [],
        product_ids: []
      )
    end

    def current_products
      [Court.where(slug: params[:court_id].to_s).last,
       Coach.where(slug: params[:coach_id].to_s).last,
       Stadium.where(slug: params[:stadium_id].to_s).last,
       Product.where(slug: params[:product_id].to_s).last].compact
    end
end
