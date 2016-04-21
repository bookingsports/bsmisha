class PaymentsController < ApplicationController
  skip_before_action :verify_authenticity_token

  before_filter :set_request_and_response

  def process
    if params["SignatureValue"] == Digest::MD5.hexdigest("#{@request.amount}:#{@request.id}:#{Rails.application.secrets.merchant_password2}")
      @request.status = :success
      @request.save
      render text: "OK#{@request.id}", status: 200
    else
      @request.status = :failure
      @request.save
      render text: "fail", status: 200
    end
  end

  def success
    if params["SignatureValue"] == Digest::MD5.hexdigest("#{@request.amount}:#{@request.id}:#{Rails.application.secrets.merchant_password2}")
      @request.status = :success
      @request.save
      redirect_to deposit_requests_url, notice: "Кошелек успешно пополнен"
    else
      @request.status = :failure
      @request.save
      redirect_to deposit_requests_url, alert: "Не удалось пополнить кошелек"
    end
  end

  def failure
    @request.status = :failure
    @request.save

    redirect_to deposit_requests_url, alert: "Не удалось пополнить кошелек"
  end

  private

  def set_request_and_response
    @request = DepositRequest.find_by(uuid: params["InvId"])
    @response = @request.deposit_responses.create(data: params.to_json)
  end
end
