class CreateCoaches < ActiveRecord::Migration
  def change
    create_table :coaches do |t|
      t.belongs_to :user, index: true, foreign_key: true
      t.string :slug
      t.string :description

      t.timestamps null: false
    end
  end
end
