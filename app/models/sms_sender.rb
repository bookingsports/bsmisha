class SmsSender
  def self.send from, to, text
    username = Rails.application.secrets.infobip_username
    password = Rails.application.secrets.infobip_password
    sms_client = OneApi::SmsClient.new(username, password)

    sms = OneApi::SMSRequest.new
    sms.sender_address = from.gsub(/[ \-()]/, "")
    sms.address = to.gsub(/[ \-()]/, "")
    sms.message = text
    #sms.callback_data = 'Any string'

    result = sms_client.send_sms(sms)
  end
end