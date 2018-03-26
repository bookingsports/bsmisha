class CreateEventGuests < ActiveRecord::Migration
  def change
    create_table :event_guests do |t|
      t.datetime :start
      t.datetime :stop
      t.string :email
      t.string :name
      t.belongs_to :group_event, index: true, foreign_key: true
      t.integer :status, default: 0
      t.timestamps null: false
    end
  end
end
