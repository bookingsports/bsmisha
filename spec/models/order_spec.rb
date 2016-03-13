# == Schema Information
#
# Table name: orders
#
#  id         :integer          not null, primary key
#  user_id    :integer
#  total      :decimal(8, 2)
#  status     :integer          default(0)
#  comment    :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'rails_helper'

RSpec.describe Order do
  let(:area) {create(:area, price: 300)}
  let(:event) {create(:event, area: area, start: Time.zone.parse('12:00')+1.day, stop: Time.zone.parse('15:00')+1.day)}
  let(:order) {create(:order, events: [event])}

  describe "#total" do
    it "returns correct value" do
      expect(order.total).to eq(event.total)
    end
  end

  describe "#pay!" do
=begin
    it "gives money to whom it belongs" do
      @order.pay!

      expect(@order.total).to eq(640)
      expect(@coach.owner.wallet.total).to eq(285)
      expect(@area.owner.wallet.total).to eq(323.0)
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
=end
  end
end
