# == Schema Information
#
# Table name: events
#
#  id                   :integer          not null, primary key
#  start                :datetime
#  end                  :datetime
#  description          :string
#  product_id           :integer
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
  before(:each) do
    full_setup
    @event = Event.create({
      start: Time.zone.parse('12:00:00'),
      end: Time.zone.parse('14:30:00'),
      user: @user
    })
  end

  describe '#occurrences' do
    it 'shows 1 if it is no repeats' do
      expect(@event.occurrences).to eq 1
    end

    it 'shows number of repeats' do
      @event.recurrence_rule = 'FREQ=DAILY;COUNT=10'

      @event.save!

      expect(@event.occurrences).to eq 10
    end
  end

  describe '#duration_in_hours' do
    it 'shows duration in hours' do
      expect(@event.duration_in_hours).to eq 2.5
    end
  end

  describe '#hours' do
    it 'returns array of hours on which event is going' do
      expect(@event.hours).to eq [12,13,14]
    end

    it 'handles one hour well' do
      @event.start = Time.zone.parse('12:30:00')
      @event.end = Time.zone.parse('13:00:00')

      expect(@event.hours).to eq [12]
    end
  end

  describe '#total' do
    it 'shows price of a courts hour' do
      @event.products = [@court]

      @event.save!

      expect(@event.total).to eq 100 * 3
    end

    it 'shows price of a courts hours times occurrences' do
      @event.recurrence_rule = 'FREQ=DAILY;COUNT=10'
      @event.products = [@court]

      @event.save!

      expect(@event.total).to eq 100 * 3 * 10
    end

    it 'special price of stadium affects the price' do
      special_price = SpecialPrice.create start: 2.days.ago, stop: 2.days.from_now
      price_rules = [DailyPriceRule.create(start: '11:00', stop: '13:00', price: 200, working_days: [Time.zone.now.wday]), DailyPriceRule.create(start: '13:00', stop: '14:00', price: 50, working_days: [Time.zone.now.wday])]
      special_price.daily_price_rules = price_rules
      special_price.save!
      @stadium.special_prices = [special_price]
      @stadium.save!
      @court.reload
      @event.products = [@court]

      @event.save!

      expect(@event.total).to eq 200 * 1 + 50 * 1 + 100 * 1
    end

    it 'special price of court affects the price' do
      special_price = SpecialPrice.create start: 2.days.ago, stop: 2.days.from_now
      price_rules = [DailyPriceRule.create(start: '11:00', stop: '13:00', price: 200, working_days: [Time.zone.now.wday]), DailyPriceRule.create(start: '13:00', stop: '14:00', price: 50, working_days: [Time.zone.now.wday])]
      special_price.daily_price_rules = price_rules
      special_price.save!
      @court.special_prices = [special_price]
      @court.save!

      @event.products = [@court]
      @event.save!

      expect(@event.total).to eq 200 * 1 + 50 * 1 + 100 * 1
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

      @event.products = [@court]
      @event.save!

      expect(@event.total).to eq 11 * 1 + 12 * 1 + 100 * 1
    end

=begin
    it 'has right total for periodic service' do
      @periodic_service = ProductService.create service: Service.new(name: 'Синема'), price: 10, product: @court, periodic: "1"

      @event.product_services << @periodic_service

      expect(@event.total).to eq 10 * 3
    end
=end

    it 'has right total for non-periodic service' do
      @non_periodic_service = ProductService.create service: Service.new(name: 'Синема'), price: 77, product: @court

      @event.product_services << @non_periodic_service

      expect(@event.total).to eq 77
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
