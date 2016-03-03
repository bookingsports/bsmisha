FactoryGirl.define do
  factory :dashboard_price, :class => 'Price' do
    start "2015-05-06 14:21:40"
    self.end "2015-05-06 14:21:40"
    price 1
    is_sale false
    area nil
  end
end
