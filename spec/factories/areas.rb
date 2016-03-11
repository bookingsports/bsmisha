# == Schema Information
#
# Table name: areas
#
#  id           :integer          not null, primary key
#  stadium_id   :integer
#  name         :string
#  description  :string
#  slug         :string
#  change_price :decimal(, )      default(0.0)
#  created_at   :datetime
#  updated_at   :datetime
#

FactoryGirl.define do
  factory :area do
    name { Faker::Commerce.product_name }
    stadium
  end
end
