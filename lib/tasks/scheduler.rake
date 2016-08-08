desc "Sending letters for confirmed and unpaid events"
task :send_letters_about_unpaid_orders => :environment do
  Event.confirmed.where(start: (Date.today.beginning_of_day + 2.days)...(Date.today.end_of_day + 2.days)).each do |event|
    puts "sending email to #{event.user.email}"
    EventMailer.confirming_event_reminder(event).deliver_now
  end
end

desc "Deleting events for tomorrow which are not paid"
task :delete_unpaid_and_confirmed_events => :environment do
  Event.confirmed.where('start < ?', Date.today.end_of_day + 1.days).each do |event|
    puts "sending email to #{event.user.email}"
    EventMailer.confirmed_event_cancelled_mail(event, nil).deliver_now
    event.coach.present? && EventMailer.confirmed_event_cancelled_notify_coach(event, nil).deliver_now
    event.destroy
  end
end