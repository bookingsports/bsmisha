require 'hmac-md5'          # Вам понадобится gem 'ruby-hmac'

class SignatureService
  attr_reader :hash

  def initialize(hash)
    @hash = hash            # Хеш с данными
  end

  def checksum              # Нужен секретный ключ из Панели управления Пэя
    HMAC::MD5.new(Rails.application.secrets.payu_secret).update(bytesized_hash(hash)).hexdigest
  end

  private

  def bytesized_hash(hash)
    base_line = ''
    hash.delete(:testorder) if hash[:testorder] != 'TRUE'
    # Подпись данных для PayU не должна учитывать 'TESTORDER', если он 'FALSE'
    hash.values.flatten.each { |value| base_line << "#{value.to_s.bytesize}#{value}" }
    base_line
  end
end