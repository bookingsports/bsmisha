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
  let!(:area) {create(:area)}
  let!(:stadium) {area.stadium}
  let!(:stadium_user) {stadium.user}
  let!(:price) {create(:price, area: area, start: Time.zone.parse("12:00") - 100.years, stop: Time.zone.parse("12:00") + 100.years)}
  let!(:daily_price_rule) {price.daily_price_rules.create value: 300, working_days: [0,1,2,3,4,5,6], start: stadium.opens_at, stop: stadium.closes_at}
  let!(:coach_user) {create(:coach_user)}
  let!(:coach_area) {CoachesArea.create coach: coach_user.coach, area: area, price: 100, stadium_percent: 50}
  let!(:event) {create(:event, area: area, start: Time.zone.parse('12:00')+1.day, stop: Time.zone.parse('15:00')+1.day, coach: coach_user.coach)}
  let!(:user) {event.user}
  let!(:order) {create(:order, events: [event], user: user)}

  describe "#total" do
    context "without recoupments" do
      it "returns correct value" do
        expect(order.total).to eq(event.price)
      end
    end

    context "with full recoupments" do
      let!(:recoupment) {Recoupment.create area: area, user: user, price: order.total + 1000}
      let!(:second_order) {create(:order, events: [event], user: user)}

      it "returns correct value" do
        expect(second_order.total).to eq(0)
      end
    end

    context "with partial recoupments" do
      let!(:recoupment) {Recoupment.create area: area, user: user, price: 500}
      let!(:third_order) {create(:order, events: [event], user: user)}

      it "returns correct value" do
        expect(third_order.total).to eq(1200 - 500)
      end
    end
  end

  describe "#pay!" do
    context "without recoupments" do
      it "gives money to whom it belongs" do
        user.wallet.deposits.create amount: 2000
        order.pay!

        expect(order.total).to eq(300 * 3 + 100 * 3)
        expect(coach_user.wallet.total).to eq((100 * 3 * (100 - Rails.application.secrets.tax) / 100) * (50.0 / 100))
        expect(stadium.user.wallet.total).to eq(300 * 3* (100 - Rails.application.secrets.tax) / 100 + (100 * 3 * (100 - Rails.application.secrets.tax) / 100) * (50.0 / 100))
        expect(user.wallet.total).to eq(2000 - 300 * 3 - 100 * 3)
      end

      it "fails when insufficient funds" do
        expect { order.pay! }.to raise_error "Недостаточно средств"
      end
    end

    context "with recoupments priced more that order's price" do
      let!(:recoupment) {Recoupment.create area: area, user: user, price: order.total + 1000}
      let!(:depositing) {user.wallet.deposits.create amount: 2000}

      it "not charges any money from user" do
        expect{order.pay!}.to_not change{ user.wallet.total }
      end
      it "not sends any money to stadium user" do
        expect{order.pay!}.to_not change{ stadium_user.wallet.total }
      end
      it "not sends any money to coach" do
        expect{order.pay!}.to_not change{ coach_user.wallet.total }
      end
    end

    context "with partial recoupments" do
      let!(:recoupment) {Recoupment.create area: area, user: user, price: 500}
      let!(:depositing) {user.wallet.deposits.create amount: 2000}

      it "charges part of money from user" do
        expect{order.pay!}.to change{ user.wallet.total }.by(-(1200 - 500))
      end
      #it "sends money to stadium user"do
      #  expect{order.pay!}.to_not change{ stadium_user.wallet.total }
      #end
      #it "sends money to coach" do
      #  expect{order.pay!}.to_not change{ coach_user.wallet.total }
      #end
    end
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
