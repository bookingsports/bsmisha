# == Schema Information
#
# Table name: events
#
#  id                   :integer          not null, primary key
#  start                :datetime
#  stop                 :datetime
#  description          :string
#  coach_id             :integer
#  area_id              :integer
#  order_id             :integer
#  user_id              :integer
#  recurrence_rule      :string
#  recurrence_exception :string
#  recurrence_id        :integer
#  is_all_day           :boolean
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#

require 'rails_helper'

RSpec.describe Event do
  let(:event) { create(:event, start: Time.zone.parse('14:00')+1.day, stop: Time.zone.parse('15:00')+1.day) }

  context 'associations' do
    it { should belong_to(:user) }
    it { should belong_to(:order) }
    it { should belong_to(:area) }
    it { should belong_to(:coach) }

    it { should have_many(:event_changes) }
    it { should have_many(:additional_event_items) }
    #it { should have_many(:special_prices) }

    it { should have_and_belong_to_many(:stadium_services) }
  end

  context 'validations' do
    subject { build(:event) }

    it { should validate_presence_of(:start) }
    it { should validate_presence_of(:stop) }
    it { should validate_presence_of(:order_id) }
    it { should validate_presence_of(:user_id) }
    it { should validate_presence_of(:area_id) }

    it 'should validate that stop is greater than start at least 30 min.' do
      event = build(:event, start: Time.zone.parse('12:00')+1.day, stop: Time.zone.parse('12:00')+1.day)
      expect(event.valid?).to be false
      expect(event.errors['stop'].count).to eq 1

      event = build(:event, start: Time.zone.parse('12:00')+1.day, stop: Time.zone.parse('12:29')+1.day)
      expect(event.valid?).to be false

      event = build(:event, start: Time.zone.parse('12:00')+1.day, stop: Time.zone.parse('12:30')+1.day)
      expect(event.valid?).to be true

      event = build(:event, start: Time.zone.parse('12:00')+1.day, stop: Time.zone.parse('11:59')+1.day)
      expect(event.valid?).to be false
    end

    it 'should validate if start or stop is not according step 30min.' do
      event = build(:event, start: Time.now + 1.minute)
      expect(event.valid?).to be false
      expect(event.errors['start'].count).to eq 1

      event = build(:event, start: Time.zone.parse('12:00')+1.day, stop: Time.zone.parse('13:05')+1.day)
      expect(event.valid?).to be false
      expect(event.errors['stop'].count).to eq 1

      event = build(:event, start: Time.zone.parse('11:59')+1.day, stop: Time.zone.parse('13:05')+1.day)
      expect(event.valid?).to be false
      expect(event.errors.count).to eq 2

      event = build(:event, start: Time.zone.parse('11:00')+1.day, stop: Time.zone.parse('13:00')+1.day)
      expect(event.valid?).to be true
      expect(event.errors.count).to eq 0
    end

    it 'should validate that start is not in the past' do
      event = build(:event, start: Time.zone.parse('12:30') - 1.day)
      expect(event.valid?).to be false
      expect(event.errors['start'].count).to eq 1
    end
  end

  context 'scopes' do
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
    end

    describe '.paid and .unpaid' do
      it 'should return only paid events' do
        order = create(:order)

        create(:event, order: order) #paid event
        3.times { create(:event) } #unpaid events

        order.paid!

        expect(Event.paid.count).to eq 1
        expect(Event.unpaid.count).to eq 3
      end
    end

    describe '.past and .future' do
      it 'should return past and future events' do
        Timecop.freeze(Date.today - 10) do
          3.times { create(:event) }
        end

        2.times { create(:event) }

        expect(Event.past.count).to eq 3
        expect(Event.future.count).to eq 2
      end
    end
  end

  context 'methods' do
    describe '#name' do
      it 'should show title for event' do
        event = build(:event, start: Time.zone.parse('2016-02-29 14:00'))
        event.stop = event.start + 2.5.hours
        expect(event.name).to eq 'Событие с 2016-02-29 14:00 по 2016-02-29 16:30'
      end
    end

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
        event.stop = event.start + 2.5.hours

        expect(event.duration_in_hours).to eq 2.5
      end
    end

    describe '#event_associated_payables' do
      it 'should return area and stadium_services in one array' do
        area = create(:area)
        stadium_service = create(:stadium_service)

        event.area = area
        event.stadium_services = [stadium_service]

        expect(event.associated_payables).to eq [area, stadium_service]
      end
    end

    describe '#event_associated_payables_with_price' do
      context 'should return hash with area and total price for each associated payable' do
        context 'without special prices' do
          let(:area) { create(:area, price: 125.0) }
          let(:stadium_service) { create(:stadium_service, price: 258.0, periodic: true) }
          let(:event) { create(:event, start: Time.zone.parse('14:00')+1.day, area: area, stadium_services: [stadium_service]) }

          it 'for one hour' do
            event.stop = event.start + 1.hour

            expect(event.associated_payables_with_price).to eq [
              {product: area, total: 125.0},
              {product: stadium_service, total: 258.0}
            ]
          end

          it 'for integer duration' do
            event.stop = event.start + 3.hours

            expect(event.associated_payables_with_price).to eq [
              {product: area, total: 125.0*3},
              {product: stadium_service, total: 258.0*3}
            ]
          end

          it 'for not periodic service' do
            stadium_service.periodic = false
            event.stop = event.start + 3.hours

            expect(event.associated_payables_with_price).to eq [
              {product: area, total: 125.0*3},
              {product: stadium_service, total: 258.0}
            ]
          end

          it 'for float duration' do
            event.stop = event.start + 3.5.hours

            expect(event.associated_payables_with_price).to eq [
              {product: area, total: 125*3.5},
              {product: stadium_service, total: 258*3.5}
            ]
          end

          it 'with 10 occurrences' do
            event.recurrence_rule = 'FREQ=DAILY;COUNT=10'
            event.stop = event.start + 3.5.hours

            expect(event.associated_payables_with_price).to eq [
              {product: area, total: 125*3.5*10},
              {product: stadium_service, total: 258*3.5*10}
            ]
          end
        end
      end

      describe '#total' do
        it 'shows price of a areas hour' do
          area = create(:area, price: 100)

          event.stop = event.start + 2.hours
          event.area = area

          expect(event.total).to eq 200.0
        end

        it 'shows price of a areas hours times occurrences' do
          area = create(:area, price: 250)

          event.recurrence_rule = 'FREQ=DAILY;COUNT=10'
          event.area = area
          event.stop = event.start + 3.5.hours
          expect(event.total).to eq 250 * 3.5 * 10
        end

        context 'periodic services' do
          let(:area) { create(:area, price: 100) }
          let(:stadium) { create(:stadium) }
          let(:service) { create(:service) }
          let(:stadium_service) { create(:stadium_service, service: service, stadium: stadium, price: 10, periodic: true) }

          before :each do
            event.area = area
            event.stadium_services << stadium_service
            event.stop = event.start + 3.hours
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
    end
  end
end
