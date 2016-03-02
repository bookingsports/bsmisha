class CreateCoachesAreas < ActiveRecord::Migration
  def change
    create_table :coaches_areas do |t|
      t.belongs_to :coach, index: true
      t.belongs_to :area, index: true
      t.decimal :price, precision: 8, scale: 2, default: 0.00
    end
  end
end
