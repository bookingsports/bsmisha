# == Schema Information
#
# Table name: event_changes
#
#  id         :integer          not null, primary key
#  event_id   :integer
#  order_id   :integer
#  old_start  :datetime
#  old_stop   :datetime
#  new_start  :datetime
#  new_stop   :datetime
#  old_price  :float
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

FactoryGirl.define do
  factory :event_change do
    event nil
    start ""
    duration_delta "MyString"
  end
end
