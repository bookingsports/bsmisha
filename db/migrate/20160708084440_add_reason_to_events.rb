class AddReasonToEvents < ActiveRecord::Migration
  def change
    add_column :events, :reason, :string
  end
end
