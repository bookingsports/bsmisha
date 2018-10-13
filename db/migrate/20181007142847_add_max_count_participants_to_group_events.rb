class AddMaxCountParticipantsToGroupEvents < ActiveRecord::Migration
  def change
    add_column :group_events, :max_count_participants, :integer
  end
end
