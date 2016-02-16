# == Schema Information
#
# Table name: special_prices
#
#  id         :integer          not null, primary key
#  start      :datetime
#  stop       :datetime
#  price      :integer
#  is_sale    :boolean
#  product_id :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
FactoryGirl.define do
  factory :special_price do
    price "1000"
    start Time.zone.now.beginning_of_year
    stop Time.zone.now.end_of_year
  end
end
