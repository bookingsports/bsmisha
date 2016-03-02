class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.datetime :start
      t.datetime :end
      t.string :description
      t.belongs_to :coach, index: true, foreign_key: true
      t.belongs_to :area, index: true, foreign_key: true
      t.belongs_to :order, index: true, foreign_key: true
      t.belongs_to :user, index: true, foreign_key: true


      t.string :recurrence_rule
      t.string :recurrence_exception
      t.integer :recurrence_id
      t.boolean :is_all_day

      t.timestamps null: false
    end
  end
end
