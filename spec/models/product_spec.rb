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
  end
end
