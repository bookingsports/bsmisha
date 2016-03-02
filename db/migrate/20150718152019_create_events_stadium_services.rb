class CreateEventsStadiumServices < ActiveRecord::Migration
  def change
    create_table :events_stadium_services do |t|
      t.belongs_to :event, index: true, foreign_key: true
      t.belongs_to :stadium_service, index: true, foreign_key: true
    end
  end
end
