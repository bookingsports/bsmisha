class CreateStaticPages < ActiveRecord::Migration
  def change
    create_table :static_pages do |t|
      t.text :text
      t.string :title

      t.timestamps null: false
    end
  end
end
