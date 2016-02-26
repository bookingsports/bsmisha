class AddProductToEvent < ActiveRecord::Migration
  def change
    add_reference :events, :product, index: true, foreign_key: true
  end
end
