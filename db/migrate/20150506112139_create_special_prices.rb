class CreateSpecialPrices < ActiveRecord::Migration
  def change
    create_table :special_prices do |t|
      t.datetime :start
      t.datetime :stop
      t.integer :price
      t.boolean :is_sale
      t.belongs_to :area, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
