#include Rails.application.routes.url_helpers

class PayuService
  attr_reader :event

  def initialize(params)
    @events = Event.where(id: params)
    @customer = @events.first.user
  end

  def send_params
    return unless @events.present?

    send_hash = shop_data.merge(order_data)

    send_hash[:order_hash] = SignatureService.new(send_hash).checksum   # Сервис для расчета контрольной суммы по ключевым данным

    send_hash.merge(account_data)     # Добавляем остальные данные, которые не влияют на контрольную сумму
  end

  private

  def shop_data
    {
        merchant: Rails.application.secrets.merchant_login,                # ID сайта в системе PayU
        order_ref: @events.first.id.to_s                                           # ID заказа
    }
  end

  def order_data
    {
        order_date: @events.first.created_at.strftime('%F %T'),
        order_pname: @events.map { |item| item.name },
        order_pcode: @events.map { |item| item.id.to_s },
        order_price: @events.map { |item| (item.price).to_s },
        order_qty: Array.new(@events.count, '1'),
        order_vat: Array.new(@events.count, '0'),
        #order_shipping: event.delivery_price,
        #prices_currency: 'RUB',
        order_mplace_merchant: @events.map {|item| Rails.application.secrets.merchant_st } ,
        testorder: Rails.application.secrets.payment_is_test.to_s.upcase,                   # Для проведения тестовых платежей
    }
  end

  def account_data
    {
        bill_fname: @customer.name,
        bill_lname: @customer.last_name,
        bill_email: @customer.email,
        bill_phone: @customer.phone,
        back_ref: "bookingsports.ru/my_events",
            #root_url(host: Rails.application.secrets.host, event_id: event.id), # URL, на который вас перенаправит после осуществления оплаты
        language: 'ru'
    }
  end
end