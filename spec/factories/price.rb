# == Schema Information
#
# Table name: special_prices
#
#  id         :integer          not null, primary key
#  start      :datetime
#  stop       :datetime
#  price      :integer
#  is_sale    :boolean
#  product_id :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
FactoryGirl.define do
  factory :price do
    start { Time.zone.parse('14:00') }
    stop { start + Faker::Number.between(1, 12).months }
    area
  end
end
