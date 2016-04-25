class PaymentsController < ApplicationController
  skip_before_action :verify_authenticity_token

  before_filter :set_request_and_response

  def process_order
    if params["SignatureValue"] == Digest::MD5.hexdigest("#{@request.amount}:#{@request.id}:#{Rails.application.secrets.merchant_password2}")
      @request.update status: :success
      render text: "OK#{@request.id}", status: 200
    else
      @request.update status: :failure
      render text: "fail", status: 200
    end
  end

  def success
    redirect_to deposit_requests_url, notice: "Кошелек успешно пополнен"
  end

  def failure
    redirect_to deposit_requests_url, alert: "Не удалось пополнить кошелек"
  end

  private

  def set_request_and_response
    @request = DepositRequest.find(params["InvId"])
    #@response = @request.deposit_responses.create(data: params.to_json)
  end
end
