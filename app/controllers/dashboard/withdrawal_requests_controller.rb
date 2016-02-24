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
    if current_user.admin?
      @request = WithdrawalRequest.find params[:id]
      send_data @request.payment.encode('Windows-1251'), type: 'text/plain', filename: "Платежная квитанция №#{@request.id}.txt"
    else
      redirect_to root_url
    end
  end

  private

    def request_params
      params.require(:withdrawal_request).permit(:amount)
    end
end
