class SetDefaultOpensAncClosesTimeForStadium < ActiveRecord::Migration
  def change
    change_column_default :stadiums, :opens_at, "07:00"
    change_column_default :stadiums, :closes_at, "23:00"
  end
end
