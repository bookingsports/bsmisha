class CreateCoachesCustomers < ActiveRecord::Migration
  def change
    create_table :coaches_customers do |t|
      t.belongs_to :coach, index: true, foreign_key: true
      t.belongs_to :user, index: true, foreign_key: true
    end
  end
end
