# == Schema Information
#
# Table name: deposits
#
#  id         :integer          not null, primary key
#  wallet_id  :integer
#  status     :integer
#  amount     :decimal(8, 2)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

FactoryGirl.define do
  factory :deposit do
    wallet nil
    status 1
    amount "9.99"
  end
end
