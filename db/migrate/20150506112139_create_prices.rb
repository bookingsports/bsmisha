class CreatePrices < ActiveRecord::Migration
  def change
    create_table :prices do |t|
      t.datetime :start
      t.datetime :stop
      t.belongs_to :area, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
