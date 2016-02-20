class ChageDataTypeForOpensAndClosesAt < ActiveRecord::Migration
  def self.up
    change_table :products do |t|
      t.change :opens_at, :time
      t.change :closes_at, :time
    end
  end
  def self.down
    change_table :products do |t|
      t.change :opens_at, :datetime
      t.change :closes_at, :datetime
    end
  end
end
