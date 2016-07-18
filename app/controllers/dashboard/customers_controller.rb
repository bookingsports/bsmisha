class Dashboard::CustomersController < DashboardController
  before_filter :find_customer, except: :index

  def index
    @customers = current_user.coach.present? ? current_user.coach.customers : []
  end

  def show
    @events = @customer.events.includes(:area, :coach).where(coach: current_user.coach).paid
    @future_events = @events.future
    @past_events = @events.past
  end

  private

    def find_customer
      @customer = User.find(params[:id]) if params[:id]
    end

end
