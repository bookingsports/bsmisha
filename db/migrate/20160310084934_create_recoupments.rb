class CreateRecoupments < ActiveRecord::Migration
  def change
    create_table :recoupments do |t|
      t.integer :duration
      t.belongs_to :user, index: true, foreign_key: true
      t.string :reason

      t.timestamps null: false
    end
  end
end
