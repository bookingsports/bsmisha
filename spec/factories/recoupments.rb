FactoryGirl.define do
  factory :recoupment do
    area
    user
    price { Faker::Commerce.price }
  end
end
