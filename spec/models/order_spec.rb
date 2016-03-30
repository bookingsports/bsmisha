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
  let(:area) {create(:area)}
  let(:price) {create(:price, area: area, start: Time.zone.parse("12:00") - 100.years, stop: Time.zone.parse("12:00") + 100.years)}
  let(:daily_price_rule) {price.daily_price_rules.first.update value: 300}
  let(:stadium) {area.stadium}
  let(:stadium_user) {stadium.user}
  let(:coach_user) {create(:coach_user)}
  let(:coach_area) {CoachesArea.create coach: coach, area: area, price: 100}
  let(:event) {create(:event, area: area, start: Time.zone.parse('12:00')+1.day, stop: Time.zone.parse('15:00')+1.day)}
  let(:user) {event.user}
  let(:order) {create(:order, events: [event])}

  describe "#total" do
    it "returns correct value" do
      expect(order.total).to eq(event.price)
    end
  end

  describe "#pay!" do
    it "gives money to whom it belongs" do
      user.wallet.deposits.create amount: 2000
      order.pay!

      expect(event.price).to eq 300*3

      expect(order.total).to eq(300 * 3)
      #expect(coach_user.wallet.total).to eq(100 * 3 * Rails.application.secrets.tax / 100)
      expect(area.user.wallet.total).to eq(300 * 3* Rails.application.secrets.tax / 100)
      expect(user.wallet.total).to eq(2000 - 300 * 3)
    end

    it "fails when insufficient funds" do
      expect { order.pay! }.not_to change {user.wallet.total}
    end

=begin
    it "sends emails to coach" do
      ActionMailer::Base.deliveries.clear

      order.pay!

      expect(ActionMailer::Base.deliveries.count).to eq(3)
      expect(ActionMailer::Base.deliveries.first.subject).to eq("⚽️ Bookingsports: Заказ оплачен!")
    end


    it "sends email about event change" do
      order.pay!
      ActionMailer::Base.deliveries.clear
      event.reload
      event.update(start: Time.now)
      event.event_change.create(summary: event.attributes.except(:id).to_json, status: :unpaid)
      new_order = Order.create(event_changes: event.event_change, user: user)
      new_order.pay!

      # puts ActionMailer::Base.deliveries.last.body
      expect(ActionMailer::Base.deliveries.count).to eq(3)
      expect(ActionMailer::Base.deliveries.first.subject).to eq("⚽️ Bookingsports: Занятие перенесено")
    end
=end
  end
end
