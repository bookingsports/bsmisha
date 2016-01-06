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
    respond_with @event
  end

  def update
    @event = current_user.events.find(params[:id])
    @event.update event_params

    respond_with @event
  end

  def edit
  end

  def show
    @event = Event.find(params[:id])

    respond_with @event
  end

  private
    def event_params
      params.require(:event).permit(Event.strong_params)
    end

    def current_products
      [Court.where(slug: params[:court_id].to_s).last,
       Coach.where(slug: params[:coach_id].to_s).last,
       Stadium.where(slug: params[:stadium_id].to_s).last,
       Product.where(slug: params[:product_id].to_s).last].compact
    end
end
