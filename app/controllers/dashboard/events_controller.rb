class Dashboard::EventsController < DashboardController
  before_filter :find_event, except: :index
  respond_to :html, :json

  def index
    @events = Event.of_products(current_products)

    respond_to do |format|
      format.json { render "events/index" }
      format.html { }
    end
  end

  def create
    @event = current_user.events.new event_params.delete_if {|k,v| v.empty? }
    @event.area = current_product

    respond_to do |format|
      format.json { render "events/_event", locals: { event: @event } }
    end
  end

  def show
    respond_with @event
  end

  private

    def find_event
      @event = Event.find(params[:id]) if params[:id]
    end

    def event_params
      params.require(:event).permit(Event.strong_params)
    end

    def current_product
      if params[:area_id]
        [Area.find(params[:area_id])]
      else
        [current_user.product]
      end
    end
end
