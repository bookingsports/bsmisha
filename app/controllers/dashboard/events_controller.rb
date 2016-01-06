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
    @order = Order.order("created_at desc").find_or_create_by(user: current_user, status: "unpaid")
    @event = @order.events.new event_params.delete_if {|k,v| v.empty? }
    @event.products = current_products

    @order.save
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

    def current_products
      if params[:court_id]
        [Court.find(params[:court_id])]
      else
        [current_user.product]
      end
    end
end
