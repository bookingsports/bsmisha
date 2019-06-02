class RestoreOrders < ActiveRecord::Migration
  def change
    create_table :orders do |t|
      t.belongs_to :user, index: true, foreign_key: true
      t.decimal :subtotal, precision: 12, scale: 2
      t.decimal :discount, precision: 8, scale: 2
      t.decimal :total, precision: 12, scale: 2
      t.integer :status, default: 0
      t.datetime :order_date

      t.timestamps null: false
    end
  end
end
