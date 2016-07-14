class AddPaidEventsCounterToStadium < ActiveRecord::Migration
  def up
    add_column :stadiums, :paid_events_counter, :integer, default: 0
    Event.all.each {|e| e.area.stadium.update_columns(paid_events_counter: Event.paid.union(Event.confirmed).uniq.where(area: e.area.stadium.area_ids).count) }
  end

  def down
    remove_column :stadiums, :paid_events_counter, :integer, default: 0
  end
end
