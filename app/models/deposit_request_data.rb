class DepositRequestData
  include Payments::Utility

  class << self
    def query_string
      "MerchantLogin={merchant_login}&OutSum={amount}&SignatureValue={signature_value}&InvDesc={order_description}&InvId={inv_id}&ResultURL={result_url}&IsTest={is_test}"
    end

    def md5_string
      "MerchantId={merchant_id}&OrderId={order_id}&Amount={amount,m}&Currency={currency}&OrderDescription={order_description}&PrivateSecurityKey={private_security_key}"
    end
  end

  attr_accessor :inv_id, :merchant_login, :amount, :order_description, :signature_value, :result_url, :is_test

  def initialize(inv_id, amount)
    @inv_id = inv_id
    @merchant_login = Rails.application.secrets.merchant_login
    @amount = amount
    @order_description = "Пополнение кошелька в системе BookingSports"
    @result_url = CGI::escape(Rails.application.secrets.payment_result_url)
    @signature_value = Digest::MD5.hexdigest("#{@merchant_login}:#{@amount}:#{@inv_id}:#{Rails.application.secrets.merchant_password1}")
    @is_test = Rails.env.production? ? "0" : "1"
  end

  def query_string
    interpolate self.class.query_string
  end

  def payment_url
    URI::encode "http://auth.robokassa.ru/Merchant/Index.aspx?#{query_string}"
  end
end
