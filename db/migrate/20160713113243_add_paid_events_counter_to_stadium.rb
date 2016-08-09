class AddPaidEventsCounterToStadium < ActiveRecord::Migration
  def up
    add_column :stadiums, :paid_events_counter, :integer, default: 0
    Event.all.each(&:update_counter_cache)
  end

  def down
    remove_column :stadiums, :paid_events_counter, :integer, default: 0
  end
end
