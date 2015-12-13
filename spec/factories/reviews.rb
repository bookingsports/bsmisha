FactoryGirl.define do
  factory :review do
    reviewable nil
    text "MyText"
    user nil
    verified false
  end
end
