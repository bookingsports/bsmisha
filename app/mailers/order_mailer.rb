class OrderMailer < ApplicationMailer
  helper :application

  def order_change order
    @order = order
    mail(to: [order.associated_emails, order.user.email], subject: "⚽️ Bookingsports: Заказ изменен - " + order.human_status)
  end

  def order_created to, events, order
    @events, @order = events, order

    mail(to: to, subject: "⚽️ Bookingsports: Заказ оплачен!")
  end
end
