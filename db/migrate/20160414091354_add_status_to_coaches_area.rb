class AddStatusToCoachesArea < ActiveRecord::Migration
  def change
    add_column :coaches_areas, :status, :integer, default: 0
  end
end
