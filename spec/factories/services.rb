# == Schema Information
#
# Table name: services
#
#  id         :integer          not null, primary key
#  name       :string
#  icon       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

FactoryGirl.define do
  factory :service do
    name { Faker::Commerce.product_name }
    icon { Faker::Placeholdit.image('50x50') }
  end
end
