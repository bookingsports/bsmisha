class Dashboard::WithdrawalRequestsController < DashboardController
  def index
    @requests = current_user.wallet.withdrawal_requests.all

    @request = current_user.wallet.withdrawal_requests.new
  end

  def create
    @request = current_user.wallet.withdrawal_requests.new request_params

    @request.save

    redirect_to dashboard_withdrawal_requests_url
  end

  def destroy
    @request = current_user.wallet.withdrawal_requests.find params[:id]
    @request.destroy!

    redirect_to dashboard_withdrawal_requests_url
  end

  def print
    @request = WithdrawalRequest.find params[:id]
    if current_user.admin?
      send_data @request.payment, type: 'text/plain', filename: "Платежная квитанция №#{@request.id}.txt"
    else
      redirect_to root_url
    end
  end

  private

    def request_params
      params.require(:withdrawal_request).permit(:amount)
    end
end
