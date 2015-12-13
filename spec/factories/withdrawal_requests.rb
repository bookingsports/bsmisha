FactoryGirl.define do
  factory :withdrawal_request do
    wallet nil
    status 1
    amount "9.99"
    data "MyText"
  end
end
