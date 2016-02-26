class CreateAccounts < ActiveRecord::Migration
  def change
    create_table :accounts do |t|
      t.string :number
      t.string :company
      t.string :inn
      t.string :kpp
      t.string :bik
      t.string :agreement_number
      t.datetime :date
      t.string :accountable_type
      t.integer :accountable_id

      t.timestamps null: false
    end
  end
end
