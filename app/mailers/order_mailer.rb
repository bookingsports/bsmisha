class OrderMailer < ApplicationMailer
  helper :application

  def order_created order
    @events, @event_changes, @order = order.events, order.event_changes, order
    mail(to: order.user.email, subject: "⚽️ Bookingsports: Заказ оплачен!")
  end

  def order_created_nofity_coach event
    @event = event
    mail(to: @event.area.stadium.user.email, subject: "⚽️ Bookingsports: Заказ оплачен!", template_name: "order_created_for_stadium")
  end

  def order_created_nofity_stadium event
    @event = event
    mail(to: @event.coach.user.email, subject: "⚽️ Bookingsports: Заказ оплачен!", template_name: "order_created_for_coach")
  end

end
