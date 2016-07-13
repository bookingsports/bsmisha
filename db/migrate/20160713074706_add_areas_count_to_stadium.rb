class AddAreasCountToStadium < ActiveRecord::Migration
  def up
    add_column :stadiums, :areas_count, :integer, default: 0
    Stadium.pluck(:id).each {|id| Stadium.reset_counters(id, :areas) }
  end

  def down
    remove_column :stadiums, :areas_count, :integer, default: 0
  end
end
