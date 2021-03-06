#include Rails.application.routes.url_helpers

class PayuService
  attr_reader :event

  def initialize(cus,order)
    @order = order
    @customer = cus
  end

  def send_params
    return unless @order.present?

    send_hash = shop_data.merge(order_data)

    send_hash[:order_hash] = SignatureService.new(send_hash).checksum   # Сервис для расчета контрольной суммы по ключевым данным

    send_hash.merge(account_data)     # Добавляем остальные данные, которые не влияют на контрольную сумму
  end

  private

  def shop_data
    {
        merchant: Rails.application.secrets.merchant_login,                # ID сайта в системе PayU
        order_ref: @order.id.to_s                                           # ID заказа
    }
  end

  def order_data
    order_data = {order_date: @order.created_at.strftime('%F %T'),
                  order_pname: [],
                  order_pcode: [],
                  order_price: [],
                  order_qty: [],
                  order_vat: [],
                  #order_shipping: event.delivery_price,
                  #prices_currency: 'RUB',
                  order_mplace_merchant: [],
                  testorder: Rails.application.secrets.payment_is_test.to_s.upcase}
    @order.order_items.each do |oi|
      if oi.event.present?
        ev_hash = oi.event.convert_for_order
      elsif oi.group_event.present?
        ev_hash = oi.group_event.convert_for_order
      elsif oi.event_change.present?
        ev_hash = oi.event_change.convert_for_order
      end
      order_data[:order_pname].push(ev_hash[:pname])
      order_data[:order_pcode].push(ev_hash[:pcode])
      order_data[:order_price].push(ev_hash[:price])
      order_data[:order_qty].push(ev_hash[:order_qty])
      order_data[:order_vat].push(ev_hash[:order_vat])
      order_data[:order_mplace_merchant].push(ev_hash[:order_mplace_merchant])
    end
    return order_data
  end

  def account_data
    {
        bill_fname: @customer.name,
        bill_lname: @customer.last_name ,
        bill_email: @customer.email,
        bill_phone: @customer.phone,
        back_ref: "http://bookingsports.ru/my_events",
        language: 'ru'
    }
  end
end