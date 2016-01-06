class DepositResponseData
  include Payments::Utility

  def self.md5_string
    "DateTime={datetime}&TransactionID={transaction_id}&OrderId={order_id}&Amount={amount}&Currency={currency}&PrivateSecurityKey={private_security_key}"
  end

  attr_reader :datetime, :transaction_id, :order_id, :amount, :currency, :private_security_key

  def initialize(params)
    params = JSON.parse params
    @datetime = params["DateTime"]
    @transaction_id = params["TransactionID"]
    @order_id = params["OrderId"]
    @amount = params["Amount"]
    @currency = params["Currency"]
    @private_security_key = Rails.application.secrets.merchant_key
  end
end
