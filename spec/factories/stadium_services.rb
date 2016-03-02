# == Schema Information
#
# Table name: stadium_services
#
#  id         :integer          not null, primary key
#  stadium_id :integer
#  service_id :integer
#  price      :float
#  periodic   :boolean          default(FALSE)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

FactoryGirl.define do
  factory :stadium_service do
    price 100
    periodic false
  end
end
