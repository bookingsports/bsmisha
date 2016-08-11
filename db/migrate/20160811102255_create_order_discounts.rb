class CreateOrderDiscounts < ActiveRecord::Migration
  def change
    create_table :order_discounts do |t|
      t.belongs_to :area, index: true, foreign_key: true, null: false
      t.float :start, null: false, default: 0
      t.integer :value, null: false, default: 0

      t.timestamps null: false
    end
  end
end
