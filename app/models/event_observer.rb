class EventObserver < ActiveRecord::Observer
  def after_save event
    if event.status_was == "for_sale" && event.paid? # if event is sold
      EventMailer.event_buying_mail(event).deliver_now
      EventMailer.event_sold_notify_old_owner(event).deliver_now
      event.coach.present? && EventMailer.event_sold_notify_coach(event).deliver_now
    elsif event.status_changed? && event.status == "paid" # after paying for event
      EventMailer.event_paid(event).deliver_now
      EventMailer.event_paid_notify_stadium(event).deliver_now
      event.coach.present? && EventMailer.event_paid_notify_coach(event).deliver_now
    elsif event.paid? && event.event_change.present? && event.event_change.paid? # paying for event change
      EventMailer.date_change_mail(event).deliver_now
      EventMailer.event_changed_notify_stadium(event).deliver_now
      event.coach.present? && EventMailer.event_changed_notify_coach(event).deliver_now
    elsif event.unpaid? && event.confirmed? && event.status_changed?
      EventMailer.event_confirmed(event).deliver_now
      EventMailer.event_confirmed_notify_stadium(event).deliver_now
      event.coach.present? && EventMailer.event_confirmed_notify_coach(event).deliver_now
    end
  end
end