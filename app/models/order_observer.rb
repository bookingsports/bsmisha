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
    order.events.group_by(&:products).each do |products, events|
      products.each do |product|
        OrderMailer.order_created(product.user.email, events, order).deliver_now
      end
      OrderMailer.order_created(order.user.email, events, order).deliver_now
    end

    order.event_changes.each do |event_change|
      event_change.products.each do |product|
        EventMailer.date_change_mail(product.user.email, event_change).deliver_now
      end

      EventMailer.date_change_mail(order.user.email, event_change).deliver_now
    end
  end
end
