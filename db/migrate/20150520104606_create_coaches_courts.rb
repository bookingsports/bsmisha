class CreateCoachesCourts < ActiveRecord::Migration
  def change
    create_table :coaches_courts do |t|
      t.belongs_to :coach, index: true
      t.belongs_to :court, index: true
      t.decimal :price, precision: 8, scale: 2, default: 0.00
    end
  end
end
