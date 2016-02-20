class Dashboard::WithdrawalRequestsController < DashboardController
  def index
    @requests = current_user.wallet.withdrawal_requests.all

    @request = current_user.wallet.withdrawal_requests.new
  end

  def create
    @request = current_user.wallet.withdrawal_requests.new request_params

    @request.save

    render action: :confirm
  end

  def confirm
    @request = current_user.wallet.withdrawal_requests.find params[:id]
  end

  def print_payment
    @request = current_user.wallet.withdrawal_requests.find params[:id]
    send_data @request.payment, type: 'text/plain', filename: "Платежная квитанция №#{@request.id}.txt"
  end

  private

    def request_params
      params.require(:withdrawal_request).permit(:amount)
    end
end
