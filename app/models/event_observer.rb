class EventObserver < ActiveRecord::Observer
  def after_update event
    if event.status_was ==  "for_sale" && event.unconfirmed?
      EventMailer.event_buying_mail(event).deliver_now
      EventMailer.event_sold_notify_old_owner(event).deliver_now
      event.coach.present? && EventMailer.event_sold_notify_coach(event).deliver_now
    elsif event.paid? && event.event_change.present? && event.event_change.paid?
      EventMailer.date_change_mail(event).deliver_now
      EventMailer.event_changed_notify_stadium(event).deliver_now
      event.coach.present? && EventMailer.event_changed_notify_coach(event).deliver_now
    elsif event.confirmed?
      EventMailer.event_confirmed(event).deliver_now
      EventMailer.event_confirmed_notify_stadium(event).deliver_now
      event.coach.present? && EventMailer.event_confirmed_notify_coach(event).deliver_now
    end
  end

  def after_destroy event
    if event.paid?
      EventMailer.event_cancelled_mail(event).deliver_now
      event.coach.present? && EventMailer.event_cancelled_notify_coach(event).deliver_now
    end
  end
end