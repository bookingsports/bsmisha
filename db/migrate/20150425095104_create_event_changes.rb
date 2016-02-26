class CreateEventChanges < ActiveRecord::Migration
  def change
    create_table :event_changes do |t|
      t.belongs_to :event, index: true, foreign_key: true
      t.integer :status
      t.string :summary
      t.belongs_to :order, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
