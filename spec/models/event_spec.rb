# == Schema Information
#
# Table name: events
#
#  id                   :integer          not null, primary key
#  start                :datetime
#  end                  :datetime
#  description          :string
#  order_id             :integer
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#  recurrence_rule      :string
#  recurrence_exception :string
#  recurrence_id        :integer
#  is_all_day           :boolean
#  user_id              :integer
#  product_id           :integer
#

require 'rails_helper'

RSpec.describe Event do
  let(:event) { create(:event, start: Time.zone.parse('14:00')) }

  describe '#occurrences' do
    it 'shows 1 if it is no repeats' do
      expect(event.occurrences).to eq 1
    end

    it 'shows number of repeats' do
      event.recurrence_rule = 'FREQ=DAILY;COUNT=10'
      expect(event.occurrences).to eq 10
    end
  end

  describe '#duration_in_hours' do
    it 'shows duration in hours' do
      event.end = event.start + 2.5.hours

      expect(event.duration_in_hours).to eq 2.5
    end
  end

  describe '#event_associated_payables' do
    it 'should return product and stadium_services in one array' do
      area = create(:area)
      stadium_service = create(:stadium_service)

      event.product = area
      event.stadium_services = [stadium_service]

      expect(event.associated_payables).to eq [area, stadium_service]
    end
  end

  describe '#event_associated_payables_with_price' do
    context 'should return hash with product and total price for each associated payable' do
      context 'without special prices' do
        let(:area) { create(:area, price: 125.0) }
        let(:stadium_service) { create(:stadium_service, price: 258.0, periodic: true) }
        let(:event) { create(:event, start: Time.zone.parse('14:00'), product: area, stadium_services: [stadium_service]) }

        it 'for one hour' do
          event.end = event.start + 1.hour

          expect(event.associated_payables_with_price).to eq [
            {product: area, total: 125.0},
            {product: stadium_service, total: 258.0}
          ]
        end

        it 'for integer duration' do
          event.end = event.start + 3.hours

          expect(event.associated_payables_with_price).to eq [
            {product: area, total: 125.0*3},
            {product: stadium_service, total: 258.0*3}
          ]
        end

        it 'for not periodic service' do
          stadium_service.periodic = false
          event.end = event.start + 3.hours

          expect(event.associated_payables_with_price).to eq [
            {product: area, total: 125.0*3},
            {product: stadium_service, total: 258.0}
          ]
        end

        it 'for float duration' do
          event.end = event.start + 3.5.hours

          expect(event.associated_payables_with_price).to eq [
            {product: area, total: 125*3.5},
            {product: stadium_service, total: 258*3.5}
          ]
        end

        it 'with 10 occurrences' do
          event.recurrence_rule = 'FREQ=DAILY;COUNT=10'
          event.end = event.start + 3.5.hours

          expect(event.associated_payables_with_price).to eq [
            {product: area, total: 125*3.5*10},
            {product: stadium_service, total: 258*3.5*10}
          ]
        end
      end
    end
  end

  describe '#total' do
    it 'shows price of a areas hour' do
      area = create(:area, price: 100)

      event.end = event.start + 2.hours
      event.product = area

      expect(event.total).to eq 200.0
    end

    it 'shows price of a areas hours times occurrences' do
      area = create(:area, price: 250)

      event.recurrence_rule = 'FREQ=DAILY;COUNT=10'
      event.product = area
      event.end = event.start + 3.5.hours

      expect(event.total).to eq 250 * 3.5 * 10
    end

=begin Disable special prices feature temporarly
    it 'special price of stadium affects the price' do
      special_price = create(:special_price, start: 2.days.ago, stop: 2.days.from_now)

      price_rules = [
        create(:daily_price_rule, start: '11:00', stop: '13:00', price: 200, working_days: [Time.zone.now.wday]),
        create(:daily_price_rule, start: '13:00', stop: '14:00', price: 50, working_days: [Time.zone.now.wday])
      ]

      special_price.daily_price_rules = price_rules

      create(:area, special_prices: [special_price])
      event.products = [area]

      expect(event.total).to eq 200 * 1 + 50 * 1 + 100 * 1
    end

    it 'special price of area affects the price' do
      special_price = SpecialPrice.create start: 2.days.ago, stop: 2.days.from_now
      price_rules = [DailyPriceRule.create(start: '11:00', stop: '13:00', price: 200, working_days: [Time.zone.now.wday]), DailyPriceRule.create(start: '13:00', stop: '14:00', price: 50, working_days: [Time.zone.now.wday])]
      special_price.daily_price_rules = price_rules
      special_price.save!
      @area.special_prices = [special_price]
      @area.save!

      event.products = [@area]
      event.save!

      expect(event.total).to eq 200 * 1 + 50 * 1 + 100 * 1
    end

    it 'special price of a area takes precedence over stadium' do
      special_price1 = SpecialPrice.create start: 2.days.ago, stop: 2.days.from_now
      special_price2 = SpecialPrice.create start: 2.days.ago, stop: 2.days.from_now
      price_rules1 = [DailyPriceRule.create(start: '11:00', stop: '13:00', price: 11, working_days: [Time.zone.now.wday]), DailyPriceRule.create(start: '13:00', stop: '14:00', price: 12, working_days: [Time.zone.now.wday])]
      price_rules2 = [DailyPriceRule.create(start: '11:00', stop: '13:00', price: 200, working_days: [Time.zone.now.wday]), DailyPriceRule.create(start: '13:00', stop: '14:00', price: 50, working_days: [Time.zone.now.wday])]
      special_price1.daily_price_rules = price_rules1
      special_price2.daily_price_rules = price_rules2
      special_price1.save
      special_price2.save

      @area.special_prices = [special_price1]
      @stadium.special_prices = [special_price2]

      event.products = [@area]
      event.save!

      expect(event.total).to eq 11 * 1 + 12 * 1 + 100 * 1
    end
=end

    context 'periodic services' do
      let(:area) { create(:area, price: 100) }
      let(:stadium) { create(:stadium) }
      let(:service) { create(:service) }
      let(:stadium_service) { create(:stadium_service, service: service, stadium: stadium, price: 10, periodic: true) }

      before :each do
        event.product = area
        event.stadium_services << stadium_service

        event.end = event.start + 3.hours
      end

      it 'has right total for periodic service' do
        expect(event.total).to eq (100 + 10) * 3
      end

      it 'has right total for non-periodic service' do
        stadium_service.periodic = false
        expect(event.total).to eq 100*3+10
      end
    end
  end

  describe '.paid_or_owned_by user' do
    before :each do
      @my_event = create(:event)
      @order = create(:order)
      @event = create(:event, order: @order)
      @user = create(:user, events: [@my_event])
    end

    it 'shows all users events' do
      expect(@user.events.count).to eq 1
      expect(Event.paid_or_owned_by(@user).count).to eq 1
      @order.paid!
      expect(Event.paid_or_owned_by(@user).count).to eq 2
    end

    it 'shows only paid if user is nil' do
      @order.paid!

      expect(Event.paid.count).to eq 1
      expect(Event.paid_or_owned_by(nil).count).to eq 1
    end
  end
end
