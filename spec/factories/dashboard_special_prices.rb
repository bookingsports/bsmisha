FactoryGirl.define do
  factory :dashboard_special_price, :class => 'SpecialPrice' do
    start "2015-05-06 14:21:40"
    self.end "2015-05-06 14:21:40"
    price 1
    is_sale false
    court nil
  end
end
