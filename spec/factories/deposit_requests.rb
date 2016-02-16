# == Schema Information
#
# Table name: deposit_requests
#
#  id         :integer          not null, primary key
#  wallet_id  :integer
#  status     :integer
#  amount     :decimal(8, 2)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  data       :text
#  uuid       :string
#

FactoryGirl.define do
  factory :deposit_request do
    wallet nil
    status 1
    amount "9.99"
  end
end
