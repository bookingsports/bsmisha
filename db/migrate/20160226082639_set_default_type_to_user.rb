class SetDefaultTypeToUser < ActiveRecord::Migration
  def change
      change_column :users, :type, :string, default: "Customer"
  end
end
