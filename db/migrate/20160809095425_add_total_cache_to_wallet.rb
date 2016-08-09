class AddTotalCacheToWallet < ActiveRecord::Migration
  def up
    add_column :wallets, :total, :float, null: false, default: 0
    Wallet.all.each(&:update_total_cache)
  end

  def down
    remove_column :wallets, :total
  end
end
