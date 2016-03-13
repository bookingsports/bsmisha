class CreateAreas < ActiveRecord::Migration
  def change
    create_table :areas do |t|
      t.belongs_to :stadium, index: true, foreign_key: true
      t.string :name
      t.string :description
      t.string :slug
      t.decimal :change_price, default: 0

      t.timestamps
    end
  end
end
