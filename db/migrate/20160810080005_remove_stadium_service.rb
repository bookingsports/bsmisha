class RemoveStadiumService < ActiveRecord::Migration
  def change
    create_table :events_services do |t|
      t.belongs_to :event, index: true, foreign_key: true
      t.belongs_to :service, index: true, foreign_key: true
    end

    add_column :services, :price, :float, null: false, default: 0
    add_column :services, :periodic, :boolean, null: false, default: false
    add_reference :services, :stadium, index: true, foreign_key: true

    reversible do |dir|
      dir.up do
        execute <<-SQL
          update services
          set (price, periodic, stadium_id) = (stadium_services.price, stadium_services.periodic, stadium_services.stadium_id)
          from stadium_services
          where services.id = stadium_services.service_id;
        SQL
      end
    end

    change_column_null :services, :stadium_id, false

    drop_table :events_stadium_services do |t|
      t.belongs_to :event, index: true, foreign_key: true
      t.belongs_to :stadium_service, index: true, foreign_key: true
    end

    drop_table :stadium_services do |t|
      t.belongs_to :stadium, index: true, foreign_key: true
      t.belongs_to :service, index: true, foreign_key: true
      t.float :price
      t.boolean :periodic, default: false

      t.timestamps null: false
    end

    rename_column :events, :stadium_services_price, :services_price
  end
end
