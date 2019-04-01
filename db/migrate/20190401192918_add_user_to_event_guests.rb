class AddUserToEventGuests < ActiveRecord::Migration
  def change
    change_table :event_guests do |t|
      t.belongs_to :user, index: true, foreign_key: true
    end
  end
end
