class CreateOrderItems < ActiveRecord::Migration
  def change
    create_table :order_items do |t|
      t.references :event, index: true, foreign_key: true
      t.references :event_change, index: true, foreign_key: true
      t.references :group_event, index: true, foreign_key: true
      t.references :order, index: true, foreign_key: true
      t.decimal :unit_price, precision: 12, scale: 2
      t.integer :quantity
      t.decimal :discount, precision: 8, scale: 2
      t.decimal :total_price, precision: 12, scale: 2

      t.timestamps null: false
    end
  end
end
