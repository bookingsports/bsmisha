class Dashboard::WithdrawalRequestsController < DashboardController
  skip_before_filter :check_if_user_is_admin!, only: :print

  def index
    @requests = current_user.wallet.withdrawal_requests.all.order("created_at desc");
    @request = current_user.wallet.withdrawal_requests.new
  end

  def create
    if current_user.type == 'CoachUser'
      if current_user.coach.blank? || current_user.coach.account.blank?
        redirect_to edit_account_dashboard_product_url, alert: "Укажите реквизиты для вывода!"
      else
        a = current_user.coach.account
        if !a.filled?
          redirect_to edit_account_dashboard_product_url, alert: "Не все реквизиты заполнены!"
        else
          @request = current_user.wallet.withdrawal_requests.new request_params
          if @request.save
            redirect_to dashboard_withdrawal_requests_url, notice: "Запрос на вывод средств создан."
          else
            redirect_to dashboard_withdrawal_requests_url, alert: "Возникла ошибка."
          end
        end
      end
    else
      a = current_user.stadium.account
      if !a.filled?
        redirect_to edit_account_dashboard_product_url, alert: "Не все реквизиты заполнены!"
      else
        @request = current_user.wallet.withdrawal_requests.new request_params
        if @request.save
          redirect_to dashboard_withdrawal_requests_url, notice: "Запрос на вывод средств создан."
        else
          redirect_to dashboard_withdrawal_requests_url, alert: "Возникла ошибка."
        end
      end
    end
  end

  def destroy
    @request = current_user.wallet.withdrawal_requests.find params[:id]
    if !@request.success?
      @request.destroy!
      redirect_to dashboard_withdrawal_requests_url
    else
      redirect_to dashboard_withdrawal_requests_url, alert: "Нельзя удалить уже подтвержденное снятие средств!"
    end
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
