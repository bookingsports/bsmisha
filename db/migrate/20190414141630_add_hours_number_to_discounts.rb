class AddHoursNumberToDiscounts < ActiveRecord::Migration
  def change
    add_column :discounts, :hours_count, :integer
    add_column :discounts, :type_user, :string
  end
end
