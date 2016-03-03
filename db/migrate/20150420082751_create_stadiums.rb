class CreateStadiums < ActiveRecord::Migration
  def change
    create_table :stadiums do |t|
      t.belongs_to :user, index: true, foreign_key: true
      t.belongs_to :category, index: true, foreign_key: true
      t.string :name, default: "Без названия", null: false
      t.string :phone
      t.string :description
      t.string :address
      t.float :latitude
      t.float :longitude
      t.string :slug
      t.integer :status, default: 0
      t.string :email
      t.string :main_image
      t.time :opens_at
      t.time :closes_at

      t.timestamps
    end
  end
end
