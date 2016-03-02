# == Schema Information
#
# Table name: areas
#
#  id           :integer          not null, primary key
#  stadium_id   :integer
#  name         :string
#  description  :string
#  slug         :string
#  price        :decimal(, )      default(0.0)
#  change_price :decimal(, )      default(0.0)
#  opens_at     :time
#  closes_at    :time
#  created_at   :datetime
#  updated_at   :datetime
#

FactoryGirl.define do
  factory :area do
    name { Faker::Commerce.product_name }
    stadium
    price { Faker::Commerce.price }
  end
end
