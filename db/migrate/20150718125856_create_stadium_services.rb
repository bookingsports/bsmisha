class CreateStadiumServices < ActiveRecord::Migration
  def change
    create_table :stadium_services do |t|
      t.belongs_to :stadium, index: true, foreign_key: true
      t.belongs_to :service, index: true, foreign_key: true
      t.float :price
      t.boolean :periodic, default: false

      t.timestamps null: false
    end
  end
end
