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
    special_price nil
    start "MyString"
    stop "MyString"
    working_days 1
  end
end
