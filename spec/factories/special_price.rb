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
  factory :special_price do
    start { Time.zone.now.beginning_of_year }
    stop { start + Faker::Number.between(1, 12).months }
    price { Faker::Commerce.price }
    is_sale true
    association :product, factory: :area
  end
end
