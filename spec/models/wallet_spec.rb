require "rails_helper"

RSpec.describe Wallet, type: :model do
  before(:each) do
    @user = User.create(email: "user@example.com", password: "blankertag")
    @admin = Admin.create(email: "admin@example.com", password: "blinkenblag")
    Option.create tax: 5
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
      tax_amt = (amt / 100 )* Option.current.tax

      expect(@user.wallet.total).to eq(amt - tax_amt)
      expect(AdminWallet.find.total).to eq(tax_amt)
    end
  end
end
