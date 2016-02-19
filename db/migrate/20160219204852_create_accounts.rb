class CreateAccounts < ActiveRecord::Migration
  def change
    create_table :accounts do |t|
      t.string :number
      t.string :company
      t.string :inn
      t.string :kpp
      t.string :bank
      t.string :bank_city
      t.string :bik
      t.string :kor

      t.timestamps null: false
    end
  end
end
