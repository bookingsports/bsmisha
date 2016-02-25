class RemoveBankAndKorFromAccount < ActiveRecord::Migration
  def change
    remove_column :accounts, :bank
    remove_column :accounts, :bank_city
    remove_column :accounts, :kor
  end
end
