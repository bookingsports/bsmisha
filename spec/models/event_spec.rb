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
#

require 'rails_helper'

RSpec.describe Event do
  let(:event) { create(:event) }

  describe '#occurrences' do
    it 'shows 1 if it is no repeats' do
      expect(event.occurrences).to eq 1
    end

    it 'shows number of repeats' do
      event.update recurrence_rule: 'FREQ=DAILY;COUNT=10'
      expect(event.occurrences).to eq 10
    end
  end

  describe '#duration_in_hours' do
    it 'shows duration in hours' do
      event.start = Time.zone.parse('14:00')
      event.end = Time.zone.parse('16:30')

      expect(event.duration_in_hours).to eq 2.5
    end
  end

  describe '#hours' do
    it 'returns array of hours on which event is going' do
      event.start = Time.zone.parse('12:00')
      event.end = Time.zone.parse('15:00')

      expect(event.hours).to eq [12,13,14]
    end

    it 'handles one hour well' do
      event.start = Time.zone.parse('12:30')
      event.end = Time.zone.parse('13:00')

      expect(event.hours).to eq [12]
    end
  end

  describe '#event_associated_payables_with_price' do
    it 'should return products and product_services in one array' do
      court = create(:court)
      product_service = create(:product_service)

      event.products = [court]
      event.product_services = [product_service]

      expect(event.associated_payables).to eq [court, product_service]
    end
  end

  describe '#event_associated_payables_with_price' do
    context 'should return hash with product and total price for each associated payable' do
      context 'without occurrences and special prices' do
        let(:court) { create(:court, price: 125) }
        let(:product_service) { create(:product_service, price: 258) }
        let(:event) { create(:event, products: [court], product_services: [product_service]) }

        it 'for one hour' do
          event.start = Time.zone.parse('14:00')
          event.end = Time.zone.parse('15:00')

          expect(event.associated_payables_with_price).to eq [
              {product: court, total: 125},
              {product: product_service, total: 258}
          ]
        end

        it 'for integer duration' do
          event.start = Time.zone.parse('14:00')
          event.end = Time.zone.parse('17:00') # duration 3

          expect(event.associated_payables_with_price).to eq [
              {product: court, total: 125*3},
              {product: product_service, total: 258*3}
          ]
        end

        it 'for float duration' do
          event.start = Time.zone.parse('14:00')
          event.end = Time.zone.parse('17:30') # duration 3.5

          expect(event.associated_payables_with_price).to eq [
              {product: court, total: 125*3.5},
              {product: product_service, total: 258*3.5}
          ]
        end
      end
    end
  end

  describe '#total' do
    it 'shows price of a courts hour' do
      court = create(:court)
      event.products = [court]

      expect(event.total).to eq court.price * event.duration_in_hours

      court.price = 100
      event.start = Time.zone.parse('12:00')
      event.end = Time.zone.parse('14:00')
      event.products = [court]

      expect(event.total).to eq 200.0
    end

    it 'shows price of a courts hours times occurrences' do
      event.recurrence_rule = 'FREQ=DAILY;COUNT=10'

      court = create(:court, price: 250)
      event.start = Time.zone.parse('07:00')
      event.end = Time.zone.parse('10:30') # duration 3.5
      event.products = [court]

      expect(event.total).to eq 250 * 3.5 * 10
    end

    it 'special price of stadium affects the price' do
      special_price = create(:special_price, start: 2.days.ago, stop: 2.days.from_now)

      price_rules = [
        create(:daily_price_rule, start: '11:00', stop: '13:00', price: 200, working_days: [Time.zone.now.wday]),
        create(:daily_price_rule, start: '13:00', stop: '14:00', price: 50, working_days: [Time.zone.now.wday])
      ]

      special_price.daily_price_rules = price_rules

      create(:court, special_prices: [special_price])
      event.products = [court]

      expect(event.total).to eq 200 * 1 + 50 * 1 + 100 * 1
    end

    it 'special price of court affects the price' do
      special_price = SpecialPrice.create start: 2.days.ago, stop: 2.days.from_now
      price_rules = [DailyPriceRule.create(start: '11:00', stop: '13:00', price: 200, working_days: [Time.zone.now.wday]), DailyPriceRule.create(start: '13:00', stop: '14:00', price: 50, working_days: [Time.zone.now.wday])]
      special_price.daily_price_rules = price_rules
      special_price.save!
      @court.special_prices = [special_price]
      @court.save!

      event.products = [@court]
      event.save!

      expect(event.total).to eq 200 * 1 + 50 * 1 + 100 * 1
    end

    it 'special price of a court takes precedence over stadium' do
      special_price1 = SpecialPrice.create start: 2.days.ago, stop: 2.days.from_now
      special_price2 = SpecialPrice.create start: 2.days.ago, stop: 2.days.from_now
      price_rules1 = [DailyPriceRule.create(start: '11:00', stop: '13:00', price: 11, working_days: [Time.zone.now.wday]), DailyPriceRule.create(start: '13:00', stop: '14:00', price: 12, working_days: [Time.zone.now.wday])]
      price_rules2 = [DailyPriceRule.create(start: '11:00', stop: '13:00', price: 200, working_days: [Time.zone.now.wday]), DailyPriceRule.create(start: '13:00', stop: '14:00', price: 50, working_days: [Time.zone.now.wday])]
      special_price1.daily_price_rules = price_rules1
      special_price2.daily_price_rules = price_rules2
      special_price1.save
      special_price2.save

      @court.special_prices = [special_price1]
      @stadium.special_prices = [special_price2]

      event.products = [@court]
      event.save!

      expect(event.total).to eq 11 * 1 + 12 * 1 + 100 * 1
    end

=begin
    it 'has right total for periodic service' do
      @periodic_service = ProductService.create service: Service.new(name: 'Синема'), price: 10, product: @court, periodic: "1"

      event.product_services << @periodic_service

      expect(event.total).to eq 10 * 3
    end
=end

    it 'has right total for non-periodic service' do
      @non_periodic_service = ProductService.create service: Service.new(name: 'Синема'), price: 77, product: @court

      event.product_services << @non_periodic_service

      expect(event.total).to eq 77
    end
  end

  describe '#paid_or_owned_by user' do
    it 'shows all users events' do
      expect(@user.events.count).to eq 4
      expect(Event.paid_or_owned_by(@user).count).to eq 4
    end

    it 'show another users only paid events' do
      @order.pay!

      expect(Event.paid.count).to eq 1
      expect(@user_two.events.count).to eq 0
      expect(Event.paid_or_owned_by(@user_two).count).to eq 1
    end

    it 'shows only paid if user is nil' do
      @order.paid!

      expect(Event.paid.count).to eq 1
      expect(Event.paid_or_owned_by(nil).count).to eq 1
    end
  end
end
