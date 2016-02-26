class CreateProductServices < ActiveRecord::Migration
  def change
    create_table :product_services do |t|
      t.belongs_to :product, index: true, foreign_key: true
      t.belongs_to :service, index: true, foreign_key: true
      t.decimal :price, precision: 8, scale: 2
      t.string :type

      t.timestamps null: false
    end
  end
end
