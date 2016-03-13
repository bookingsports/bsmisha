# == Schema Information
#
# Table name: daily_price_rules
#
#  id           :integer          not null, primary key
#  price_id     :integer
#  start        :time
#  stop         :time
#  value        :integer
#  working_days :integer          default([]), is an Array
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

FactoryGirl.define do
  factory :daily_price_rule do
    price
    start { Time.zone.parse("#{Faker::Number.between(7, 20)}:00") }
    stop { start + Faker::Number.between(1, 3).hours }
    value { Faker::Commerce.price }
    working_days [Faker::Number.between(1, 7), Faker::Number.between(1, 7)]
  end
end
