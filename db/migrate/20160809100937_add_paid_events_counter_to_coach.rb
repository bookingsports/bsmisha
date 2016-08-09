class AddPaidEventsCounterToCoach < ActiveRecord::Migration
  def up
    add_column :coaches, :paid_events_counter, :integer, default: 0
    Event.all.each(&:update_counter_cache)
  end

  def down
    remove_column :coaches, :paid_events_counter, :integer, default: 0
  end
end
