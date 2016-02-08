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
    product nil
    service nil
    price "9.99"
  end
end
