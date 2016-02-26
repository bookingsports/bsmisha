class CreateAdditionalOrderItems < ActiveRecord::Migration
  def change
    create_table :additional_event_items do |t|
      t.references :related, polymorphic: true, index: true
      t.belongs_to :event, index: true, foreign_key: true
      t.integer :amount, default: 1

      t.timestamps null: false
    end
  end
end
