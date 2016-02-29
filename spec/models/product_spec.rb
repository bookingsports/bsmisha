# == Schema Information
#
# Table name: products
#
#  id           :integer          not null, primary key
#  category_id  :integer
#  user_id      :integer
#  name         :string
#  phone        :string
#  description  :text
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  address      :string
#  latitude     :float            default(55.75)
#  longitude    :float            default(37.61)
#  slug         :string
#  status       :integer          default(0)
#  type         :string
#  parent_id    :integer
#  email        :string
#  avatar       :string
#  price        :float
#  change_price :float
#  opens_at     :time
#  closes_at    :time
#

require 'rails_helper'

RSpec.describe Product do
  describe '#price_for_event' do
    it 'should return sum of prices for event if no special prices provided' do
      area = create :area, price: 100

      event = create :event, start: Time.zone.parse('14:00'), product: area
      event.end = event.start + 3.5.hours

      expect(area.price_for_event(event)).to eq 100*3.5
    end

=begin Disable special prices feature temporarly
    it 'should return sum of prices and special_prices for event if special prices provided' do
      area = create :area, price: 100

      event = create :event, start: Time.zone.parse('14:00'), product: area
      event.end = event.start + 3.5.hours

      special_price = create :special_price, start: event.start - 1.hour, stop: event.start + 2.hour, price: 200

      area.special_prices = [special_price]

      expect(area.price_for_event(event)).to eq 200*2+100*1.5
    end
=end
  end
end
