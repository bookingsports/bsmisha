class CreateGroupEvents < ActiveRecord::Migration
  def change
    create_table :group_events do |t|

      t.datetime :start
      t.datetime :stop
      t.string :name
      t.string :description
      t.belongs_to :coach, index: true, foreign_key: true
      t.belongs_to :area, index: true, foreign_key: true
      t.belongs_to :user, index: true, foreign_key: true
      t.float :price

      t.string :recurrence_rule
      t.string :recurrence_exception
      t.integer :recurrence_id
      t.boolean :is_all_day

      t.integer :status, default: 0


      t.timestamps null: false
    end
  end
end


