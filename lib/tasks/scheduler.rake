desc "Sending letters for confirmed and unpaid events"
task :send_letters_about_unpaid_orders => :environment do
  Event.unpaid.confirmed.future.where(start: (Date.today.beginning_of_day + 2.days)...(Date.today.end_of_day + 2.days)).each do |event|
    puts "sending email to #{event.user.name}"
    EventMailer.confirming_event_reminder(event).deliver_now
  end
end

desc "Deleting events for tomorrow which are not paid"
task :delete_unpaid_and_confirmed_events => :environment do
  Event.unpaid.confirmed.future.where(start: (Date.today.beginning_of_day + 1.days)...(Date.today.end_of_day + 1.days)).destroy_all
end