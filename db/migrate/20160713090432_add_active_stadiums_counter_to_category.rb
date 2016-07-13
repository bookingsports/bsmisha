class AddActiveStadiumsCounterToCategory < ActiveRecord::Migration
  def up
    add_column :categories, :active_stadiums_counter, :integer, default: 0
    Category.all.each { |c| c.update_columns active_stadiums_counter: c.stadiums.active.count }
  end

  def down
    remove_column :categories, :active_stadiums_counter, :integer, default: 0
  end
end
