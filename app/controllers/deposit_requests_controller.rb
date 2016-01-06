class DepositRequestsController < DashboardController
  def index
    @requests = current_user.wallet.deposit_requests.order(created_at: :desc).first(10)
  end

  def show
  end

  def create
    @request = current_user.wallet.deposit_requests.new dr_params
    if @request.save
      redirect_to @request.data.payment_url
    else
      redirect_to dashboard_deposit_requests_path, alert: "Кошелек не удалось пополнить. Свяжитесь с администратором пожалуйста назвав свой логин."
    end
  end

  def new
  end

  private

    def dr_params
      params.require(:deposit_request).permit(:amount)
    end
end
