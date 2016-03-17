class CreateEventChanges < ActiveRecord::Migration
  def change
    create_table :event_changes do |t|
      t.belongs_to :event, index: true, foreign_key: true
      t.belongs_to :order, index: true, foreign_key: true
      t.datetime :old_start
      t.datetime :old_stop
      t.datetime :new_start
      t.datetime :new_stop
      t.float :old_price

      t.timestamps null: false
    end
  end
end
