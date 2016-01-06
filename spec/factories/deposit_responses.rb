FactoryGirl.define do
  factory :deposit_response do
    deposit_request nil
    status 1
    data "MyText"
  end
end
