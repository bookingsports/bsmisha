class OrderObserver < ActiveRecord::Observer
  def after_update order
    if order.status_changed?
      case order.status
      when "paid"
        send_emails_about_payed_order order
      end
    end
  end

  def send_emails_about_payed_order order
    OrderMailer.order_created(order).deliver_now
    order.events.each do |event|
      OrderMailer.order_created_nofity_coach(event).deliver_now
      event.coach.present? && OrderMailer.order_created_nofity_stadium(event).deliver_now
    end
  end
end
