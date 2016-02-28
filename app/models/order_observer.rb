class OrderObserver < ActiveRecord::Observer
  def after_update order
    if order.status_changed?
      case order.status
      when "paid"
        send_emails_about_payed_order order
      else
        OrderMailer.order_change(order).deliver_now
      end
    end
  end

  def send_emails_about_payed_order order
    OrderMailer.order_created(order).deliver_now
  end
end
