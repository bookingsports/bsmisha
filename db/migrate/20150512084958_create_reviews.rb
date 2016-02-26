class CreateReviews < ActiveRecord::Migration
  def change
    create_table :reviews do |t|
      t.references :reviewable, polymorphic: true, index: true
      t.text :text
      t.belongs_to :user, index: true, foreign_key: true
      t.boolean :verified
      t.integer :rating

      t.timestamps null: false
    end
  end
end
