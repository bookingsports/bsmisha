class Dashboard::CustomersController < DashboardController
  before_filter :find_customer, except: :index

  def index
    @customers = current_user.coach.customers
  end

  private

    def find_customer
      @customer = User.find(params[:id]) if params[:id]
    end
end
