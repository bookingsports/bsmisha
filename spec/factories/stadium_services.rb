# == Schema Information
#
# Table name: product_services
#
#  id         :integer          not null, primary key
#  product_id :integer
#  service_id :integer
#  price      :float
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  periodic   :boolean          default(FALSE)
#

FactoryGirl.define do
  factory :stadium_service do
    price 100
    periodic false
  end
end
