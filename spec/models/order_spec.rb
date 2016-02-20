# == Schema Information
#
# Table name: orders
#
#  id         :integer          not null, primary key
#  user_id    :integer
#  total      :decimal(8, 2)
#  status     :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  comment    :string
#

require "rails_helper"

RSpec.describe Order, type: :model do
  before(:each) do
    full_setup
  end

  describe "#total" do
    it "returns correct value" do
      expect(@order.total).to eq(@event.total)
    end
  end

  describe "#pay!" do
    it "gives money to whom it belongs" do
      @order.pay!

      expect(@order.total).to eq(640)
      expect(@coach.owner.wallet.total).to eq(285)
      expect(@court.owner.wallet.total).to eq(323.0)
      expect(AdminWallet.find.total).to eq(640 - (285 + 323.0))
      expect(@user.wallet.total).to eq(360)
    end

    it "fails when insufficient funds" do
      @user.wallet.withdraw! 1000

      expect { @order.pay! }.to raise_error(RuntimeError)
    end

    it "sends emails to coach" do
      ActionMailer::Base.deliveries.clear

      @order.pay!

      expect(ActionMailer::Base.deliveries.count).to eq(3)
      expect(ActionMailer::Base.deliveries.first.subject).to eq("⚽️ Bookingsports: Заказ оплачен!")
    end

    it "sends email about event change" do
      @order.pay!
      ActionMailer::Base.deliveries.clear
      @event.reload
      @event.update(start: Time.now)
      @event.event_changes.create(summary: @event.attributes.except(:id).to_json, status: :unpaid)
      @new_order = Order.create(event_changes: @event.event_changes, user: @user)
      @new_order.pay!

      # puts ActionMailer::Base.deliveries.last.body
      expect(ActionMailer::Base.deliveries.count).to eq(3)
      expect(ActionMailer::Base.deliveries.first.subject).to eq("⚽️ Bookingsports: Занятие перенесено")
    end
  end
end
