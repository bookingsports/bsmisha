class AddLowestPriceToStadium < ActiveRecord::Migration
  def up
    add_column :stadiums, :lowest_price, :integer
    Stadium.all.each do |s|
      s.update_columns lowest_price: s.daily_price_rules.any? ? s.daily_price_rules.reorder('value asc').first.value : nil
    end
  end

  def down
    remove_column :stadiums, :lowest_price, :integer
  end
end
