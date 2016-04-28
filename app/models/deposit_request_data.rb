class DepositRequestData
  include Payments::Utility

  def query_string
    interpolate "MerchantLogin={merchant_login}&OutSum={amount}&SignatureValue={signature_value}&InvDesc={order_description}&InvId={inv_id}&IsTest={is_test}"
  end

  def md5_string
    "MerchantId={merchant_id}&OrderId={order_id}&Amount={amount,m}&Currency={currency}&OrderDescription={order_description}&PrivateSecurityKey={private_security_key}"
  end

  attr_accessor :inv_id, :merchant_login, :amount, :order_description, :signature_value, :result_url, :is_test, :payment_method, :shop_id, :scid, :customer_number

  def initialize(inv_id, amount, payment_method, customer_number)
    @payment_method = payment_method
    @inv_id = inv_id
    @merchant_login = Rails.application.secrets.merchant_login
    @amount = amount
    @order_description = "Пополнение кошелька в системе BookingSports"
    @result_url = CGI::escape(Rails.application.secrets.payment_result_url)
    @signature_value = Digest::MD5.hexdigest("#{@merchant_login}:#{@amount}:#{@inv_id}:#{Rails.application.secrets.merchant_password1}")
    @is_test = Rails.application.secrets.payment_is_test
    @shop_id = Rails.application.secrets.shop_id
    @scid = Rails.application.secrets.scid
    @customer_number = inv_id
  end

  def payment_url
    URI::encode "http://auth.robokassa.ru/Merchant/Index.aspx?#{query_string}"
  end

  def redirect_via_post
    %Q{<form action="https://money.yandex.ru/eshop.xml" method="post">#{yandex_kassa_params.map{|k,v| %Q{<input type=
"hidden" name="#{k}" value="#{v}" />}}.join('')}</form><script>document.forms[0].submit()</script>}
  end

  def yandex_kassa_params
    {shopId: shop_id, scid: scid, sum: amount, customerNumber: customer_number, orderNumber: inv_id}
  end
end
