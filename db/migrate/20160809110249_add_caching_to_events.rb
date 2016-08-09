class AddCachingToEvents < ActiveRecord::Migration
  def up
    add_column :events, :area_price, :float, null: false, default: 0
    add_column :events, :coach_price, :float, null: false, default: 0
    add_column :events, :stadium_services_price, :float, null: false, default: 0
    Event.all.each(&:update_price_cache)
  end

  def down
    remove_column :events, :area_price, :float, null: false, default: 0
    remove_column :events, :coach_price, :float, null: false, default: 0
    remove_column :events, :stadium_services_price, :float, null: false, default: 0
  end
end
