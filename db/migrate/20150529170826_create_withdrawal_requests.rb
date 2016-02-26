class CreateWithdrawalRequests < ActiveRecord::Migration
  def change
    create_table :withdrawal_requests do |t|
      t.belongs_to :wallet, index: true, foreign_key: true
      t.integer :status, default: 0
      t.decimal :amount, precision: 8, scale: 2
      t.text :data
      t.text :payment

      t.timestamps null: false
    end
  end
end
