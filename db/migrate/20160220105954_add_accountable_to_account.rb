class AddAccountableToAccount < ActiveRecord::Migration
  def change
    add_column :accounts, :accountable_type, :string
    add_column :accounts, :accountable_id, :string
  end
end
