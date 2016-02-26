# == Schema Information
#
# Table name: product_services
#
#  id         :integer          not null, primary key
#  product_id :integer
#  service_id :integer
#  price      :decimal(8, 2)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  type       :string
#

FactoryGirl.define do
  factory :product_service do
    price 100
    periodic false
  end
end
