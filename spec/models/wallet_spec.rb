# == Schema Information
#
# Table name: wallets
#
#  id         :integer          not null, primary key
#  user_id    :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'rails_helper'

RSpec.describe Wallet do
  before(:each) do
    @user = User.create(name: 'Test User', email: "user@example.com", password: "blankertag")
    @admin = Admin.create(name: 'Test Admin', email: "admin@example.com", password: "blinkenblag")
  end

  subject { @user.wallet }

  describe "#deposit!" do
    it "enlarges the money amount" do
      @user.wallet.deposit! 500
      expect(@user.wallet.total).to eq(500)
    end
  end

  describe "#deposit_with_tax_deduction!" do
    it "enlarges the money slightly but admin gets something too" do
      amt = 500
      @user.wallet.deposit_with_tax_deduction! amt
      tax_amt = (amt / 100 )* Rails.application.secrets.tax

      expect(@user.wallet.total).to eq(amt - tax_amt)
    end
  end
end
