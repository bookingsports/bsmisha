class AddDiscountsToDailyPriceRules < ActiveRecord::Migration
  def change
    add_column :daily_price_rules, :is_discount, :boolean, default: false

    DailyPriceRule.update_all is_discount: false
  end
end
