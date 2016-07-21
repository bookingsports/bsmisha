class EventMailer < ApplicationMailer
  def date_change_mail event
    @event = event
    mail(to: @event.user.email, subject: "⚽️ Bookingsports: Занятие перенесено")
  end

  def event_cancelled_mail event
    @event = event
    mail(to: @event.user.email, subject: "⚽️ Bookingsports: Занятие отменено администратором стадиона")
  end

  def event_cancelled_notify_coach event
    @event = event
    mail(to: @event.coach.user.email, subject: "⚽️ Bookingsports: Занятие отменено администратором стадиона")
  end

  def event_cancelled_notify_stadium event
    @event = event
    mail(to: @event.area.stadium.user.email, subject: "⚽️ Bookingsports: Занятие отменено администратором стадиона")
  end

  def confirmed_event_cancelled_mail event
    @event = event
    mail(to: @event.user.email, subject: "⚽️ Bookingsports: Забронированное занятие отменено покупателем")
  end

  def confirmed_event_cancelled_notify_coach event
    @event = event
    mail(to: @event.coach.user.email, subject: "⚽️ Bookingsports: Забронированное занятие отменено покупателем")
  end

  def confirmed_event_cancelled_notify_stadium event
    @event = event
    mail(to: @event.area.stadium.user.email, subject: "⚽️ Bookingsports: Забронированное занятие отменено покупателем")
  end

  def event_confirmed event
    @event = event
    mail(to: @event.user.email, subject: "⚽️ Bookingsports: Занятие забронировано")
  end

  def event_confirmed_notify_coach event
    @event = event
    mail(to: @event.coach.user.email, subject: "⚽️ Bookingsports: Занятие забронировано")
  end

  def event_confirmed_notify_stadium event
    @event = event
    mail(to: @event.area.stadium.user.email, subject: "⚽️ Bookingsports: Занятие забронировано")
  end

  def event_changed_notify_coach event
    @event = event
    mail(to: @event.coach.user.email, subject: "⚽️ Bookingsports: Занятие перенесено")
  end

  def event_changed_notify_stadium event
    @event = event
    mail(to: @event.area.stadium.user.email, subject: "⚽️ Bookingsports: Занятие перенесено")
  end

  def event_buying_mail event
    @event = event
    mail(to: @event.user.email, subject: "⚽️ Bookingsports: Заказ куплен")
  end

  def event_sold_notify_old_owner event
    @event = event
    @user = User.find(@event.user_id_was)
    mail(to: @user.email, subject: "⚽️ Bookingsports: Заказ продан")
  end

  def event_sold_notify_coach event
    @event = event
    mail(to: @event.coach.user.email, subject: "⚽️ Bookingsports: Заказ продан")
  end

  def confirming_event_reminder event
    @event = event
    mail(to: @event.user.email, subject: "⚽️ Bookingsports: Напоминание о бронировании заказа")
  end
end
