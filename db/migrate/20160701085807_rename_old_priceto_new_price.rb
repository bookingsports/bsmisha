class RenameOldPricetoNewPrice < ActiveRecord::Migration
  def change
    rename_column :event_changes, :old_price, :new_price
  end
end
