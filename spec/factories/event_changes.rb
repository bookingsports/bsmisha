# == Schema Information
#
# Table name: event_changes
#
#  id         :integer          not null, primary key
#  event_id   :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  status     :integer
#  summary    :string
#  order_id   :integer
#

FactoryGirl.define do
  factory :event_change do
    event nil
    start ""
    duration_delta "MyString"
  end
end
