# == Schema Information
#
# Table name: prices
#
#  id         :integer          not null, primary key
#  start      :datetime
#  stop       :datetime
#  area_id    :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'rails_helper'

RSpec.describe Price do
  let(:price) { create(:price) }

  context 'associations' do
    it { should belong_to(:area) }
    it { should have_many(:daily_price_rules).dependent(:destroy) }
  end

  context 'validations' do
    it { should validate_presence_of(:area_id) }
    it { should validate_presence_of(:start) }
    it { should validate_presence_of(:stop) }

    it 'should validate that stop is greater than start at least 30 min.' do
      price = build(:price, start: Time.zone.parse('12:00')+1.day, stop: Time.zone.parse('12:00')+1.day)
      expect(price.valid?).to be false
      expect(price.errors['stop'].count).to eq 1

      price = build(:price, start: Time.zone.parse('12:00')+1.day, stop: Time.zone.parse('12:29')+1.day)
      expect(price.valid?).to be false

      price = build(:price, start: Time.zone.parse('12:00')+1.day, stop: Time.zone.parse('12:30')+1.day)
      expect(price.valid?).to be true

      price = build(:price, start: Time.zone.parse('12:00')+1.day, stop: Time.zone.parse('11:59')+1.day)
      expect(price.valid?).to be false
    end

    it 'should validate if start or stop is not according step 30min.' do
      price = build(:price, start: Time.now + 1.minute)
      expect(price.valid?).to be false
      expect(price.errors['start'].count).to eq 1

      price = build(:price, start: Time.zone.parse('12:00')+1.day, stop: Time.zone.parse('13:05')+1.day)
      expect(price.valid?).to be false
      expect(price.errors['stop'].count).to eq 1

      price = build(:price, start: Time.zone.parse('11:59')+1.day, stop: Time.zone.parse('13:05')+1.day)
      expect(price.valid?).to be false
      expect(price.errors.count).to eq 2

      price = build(:price, start: Time.zone.parse('11:00')+1.day, stop: Time.zone.parse('13:00')+1.day)
      expect(price.valid?).to be true
      expect(price.errors.count).to eq 0
    end

    it 'should validate that price cover all working hours'
  end
end
