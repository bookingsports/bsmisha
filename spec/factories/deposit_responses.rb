# == Schema Information
#
# Table name: deposit_responses
#
#  id                 :integer          not null, primary key
#  deposit_request_id :integer
#  status             :integer
#  data               :text
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#

FactoryGirl.define do
  factory :deposit_response do
    deposit_request nil
    status 1
    data "MyText"
  end
end
