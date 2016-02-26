class ChangeTypeToPeriodicForProductServices < ActiveRecord::Migration
  def change
    remove_column :product_services, :type, :string
    add_column :product_services, :periodic, :boolean, default: false
  end
end
