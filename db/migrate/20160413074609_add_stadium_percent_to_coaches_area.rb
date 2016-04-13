class AddStadiumPercentToCoachesArea < ActiveRecord::Migration
  def change
    add_column :coaches_areas, :stadium_percent, :float, default: 0
  end
end
