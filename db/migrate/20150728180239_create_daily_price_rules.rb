class CreateDailyPriceRules < ActiveRecord::Migration
  def change
    create_table :daily_price_rules do |t|
      t.belongs_to :price, index: true, foreign_key: true
      t.string :start
      t.string :stop
      t.integer :price
      t.integer :working_days, array: true, default: []

      t.timestamps null: false
    end
  end
end
