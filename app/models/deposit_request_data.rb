class DepositRequestData
  include Payments::Utility

  class << self
    def query_string
      "MerchantId={merchant_id}&ReturnUrl={return_url}&OrderId={order_id}&Amount={amount,m}&Currency={currency}&SecurityKey={security_key}&OrderDescription={order_description}"
    end

    def md5_string
      "MerchantId={merchant_id}&OrderId={order_id}&Amount={amount,m}&Currency={currency}&OrderDescription={order_description}&PrivateSecurityKey={private_security_key}"
    end
  end

  attr_accessor :order_id, :merchant_id, :amount, :currency, :order_description, :private_security_key, :return_url

  def initialize(order_id, amount)
    @order_id = order_id
    @merchant_id = Rails.application.secrets.merchant_id
    @amount = amount
    @currency = "RUB"
    @order_description = "Пополнение кошелька в системе BookingSports"
    @return_url = CGI::escape(Rails.application.secrets.payment_result_url)
    @private_security_key = Rails.application.secrets.merchant_key
  end

  def query_string
    interpolate self.class.query_string
  end

  def payment_url
    URI::encode "https://secure.payonlinesystem.com/ru/payment/select?#{query_string}"
  end
end
