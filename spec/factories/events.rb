# == Schema Information
#
# Table name: events
#
#  id                   :integer          not null, primary key
#  start                :datetime
#  end                  :datetime
#  description          :string
#  product_id           :integer
#  order_id             :integer
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#  recurrence_rule      :string
#  recurrence_exception :string
#  recurrence_id        :integer
#  is_all_day           :boolean
#  user_id              :integer
#

FactoryGirl.define do
  factory :event do
    start "2015-04-21 13:12:09"
    self.end "2015-04-21 13:12:09"
    description "MyString"
    order nil
  end
end
