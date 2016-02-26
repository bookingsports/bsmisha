# == Schema Information
#
# Table name: daily_price_rules
#
#  id               :integer          not null, primary key
#  special_price_id :integer
#  start            :string
#  stop             :string
#  price            :integer
#  working_days     :integer          default([]), is an Array
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#

FactoryGirl.define do
  factory :daily_price_rule do
    special_price
    start { Time.zone.parse("#{Faker::Number.between(7, 20).hours}:00") }
    stop { start + Faker::Number.between(1, 3).hours}
    price { Faker::Commerce.price }
    working_days [Faker::Number.between(1, 7), Faker::Number.between(1, 7)]
  end
end
