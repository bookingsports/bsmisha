# == Schema Information
#
# Table name: withdrawal_requests
#
#  id         :integer          not null, primary key
#  wallet_id  :integer
#  status     :integer
#  amount     :decimal(8, 2)
#  data       :text
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

FactoryGirl.define do
  factory :withdrawal_request do
    wallet nil
    status 1
    amount "9.99"
    data "MyText"
  end
end
