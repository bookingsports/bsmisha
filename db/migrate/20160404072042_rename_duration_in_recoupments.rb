class RenameDurationInRecoupments < ActiveRecord::Migration
  def change
    rename_column :recoupments, :duration, :price
  end
end
