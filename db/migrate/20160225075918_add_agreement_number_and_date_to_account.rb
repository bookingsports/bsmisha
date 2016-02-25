class AddAgreementNumberAndDateToAccount < ActiveRecord::Migration
  def change
    add_column :accounts, :agreement_number, :string
    add_column :accounts, :date, :datetime
  end
end
