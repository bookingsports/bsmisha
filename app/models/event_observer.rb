class EventObserver < ActiveRecord::Observer
  def after_update event
    if event.paid? && event.start_changed?
      EventMailer.date_change_mail(event).deliver_now
    end
  end
end