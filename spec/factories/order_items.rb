FactoryGirl.define do
  factory :order_item do
    event nil
    event_change nil
    group_event nil
    order nil
    unit_price "9.99"
    quantity 1
    discount "9.99"
    total_price "9.99"
  end
end
