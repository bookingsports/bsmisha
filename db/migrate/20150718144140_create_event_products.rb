class CreateEventProducts < ActiveRecord::Migration
  def change
    create_table :events_products do |t|
      t.belongs_to :event, index: true
      t.belongs_to :product, index: true
    end
  end
end
