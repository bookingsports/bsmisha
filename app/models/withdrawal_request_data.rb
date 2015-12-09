class WithdrawalRequestData
  include Payments::Utility

  class << self
    def params
      "MerchantId&ReturnUrl&OrderId&Amount&Currency&SecurityKey&OrderDescription&PayRequsites".split('&')
    end

    def md5_string
      "MerchantId={merchant_id}&OrderId={order_id}&Amount={amount,m}&Currency={currency}&OrderDescription={order_description}&PrivateSecurityKey={private_security_key}&PayRequsites={pay_requsites}"
    end
  end

  attr_accessor :order_id, :merchant_id, :amount, :currency, :order_description, :private_security_key, :return_url, :pay_requsites

  def initialize order_id, amount
    @order_id = order_id
    @merchant_id = Rails.application.secrets.merchant_id
    @amount = amount
    @currency = 'RUB'
    @order_description = "Вывод средств из системы BookingSports"
    @return_url = CGI::escape(Rails.application.secrets.payment_result_url)
    @private_security_key = Rails.application.secrets.merchant_key
    @pay_requsites = '321'
  end

  def query_string
    interpolate self.class.query_string
  end

  def amount
    ActionController::Base.helpers.number_with_precision @amount, precision: 2, separator: '.'
  end

  def payment_url
    "https://secure.payonlinesystem.com/ru/payment/"
  end

  def form_fields
    WithdrawalRequestData.params.map do |param|
      ActionController::Base.helpers.hidden_field_tag param, self.send(param.underscore)
    end
  end
end
