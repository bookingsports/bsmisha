class CreateProducts < ActiveRecord::Migration
  def change
    create_table :products do |t|
      t.belongs_to :category, index: true, foreign_key: true
      t.belongs_to :user, index: true, foreign_key: true
      t.belongs_to :parent, index: true
      t.string :name
      t.string :phone
      t.text :description
      t.string :address
      t.float :latitude, default: 55.75
      t.float :longitude, default: 37.61
      t.string :slug
      t.integer :status, default: 0
      t.string :type
      t.string :email
      t.string :avatar
      t.float :price
      t.float :change_price
      t.time :opens_at
      t.time :closes_at

      t.timestamps null: false
    end
  end
end
