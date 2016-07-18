class AddHighestPriceToStadium < ActiveRecord::Migration
  def up
    add_column :stadiums, :highest_price, :integer
    Stadium.all.each do |s|
      s.update_columns highest_price: s.daily_price_rules.any? ? s.daily_price_rules.reorder('value desc').first.value : nil
    end
  end

  def down
    remove_column :stadiums, :highest_price, :integer
  end
end
