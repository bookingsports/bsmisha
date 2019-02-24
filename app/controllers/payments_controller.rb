class PaymentsController < ApplicationController
  skip_before_action :verify_authenticity_token

  before_filter :set_request_and_response

  def process_order
    if @request.robokassa?
      if params["SignatureValue"] == Digest::MD5.hexdigest("#{params["OutSum"]}:#{@request.id}:#{Rails.application.secrets.merchant_password2}").upcase
        @request.update status: :success
        render text: "OK#{@request.id}", status: 200
      else
        @request.update status: :failure
        render text: "fail", status: 200
      end
    else
      if valid_signature?
        @request.update status: :success
      else
        @request.update status: :failure
      end

      xml = Builder::XmlMarkup.new
      xml.instruct! :xml, version: '1.0', encoding: 'UTF-8'
      xml.paymentAvisoResponse(performedDatetime: Time.current.iso8601,
                               code: code_process,
                               invoiceId: params[:invoice_id],
                               shopId: Rails.application.secrets.shop_id
      )
      xml.target!
      render text: xml
    end
  end

  def check_order
    xml = Builder::XmlMarkup.new
    xml.instruct! :xml, version: '1.0', encoding: 'UTF-8'

    xml.checkOrderResponse(performedDatetime: Time.current.iso8601,
      code: code_check,
      invoiceId: params[:invoice_id],
      shopId: Rails.application.secrets.shop_id
    )
    xml.target!
    render text: xml
  end

  def success
    redirect_to deposit_requests_url, notice: "Кошелек успешно пополнен"
  end

  def failure
    redirect_to deposit_requests_url, alert: "Не удалось пополнить кошелек"
  end

  private

  def set_request_and_response
    if params["InvId"].present?
      @request = DepositRequest.find(params["InvId"])
    else
      @request = DepositRequest.find(params["orderNumber"])
    end
  end

  def yandex_kassa_signature_valid?
    Digest::MD5.hexdigest([params[:order_sum_amount], params[:order_sum_currency_paycash], params[:order_sum_bank_paycash], params[:shop_id], params[:invoice_id], params[:customer_number], Rails.application.secrets.shop_password].join(';')).upcase == params[:md5]
  end

  def code_check
    if valid_signature?
      valid_params? ? '0' : '100'
    else
      '1'
    end
  end

  def code_process
    valid_signature? ? '0' : '1'
  end

  def valid_params?
    if @request
      @request.amount == params[:order_sum_amount].to_i
    else
      false
    end
  end
end
