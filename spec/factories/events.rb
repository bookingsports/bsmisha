# == Schema Information
#
# Table name: events
#
#  id                   :integer          not null, primary key
#  start                :datetime
#  end                  :datetime
#  description          :string
#  coach_id             :integer
#  area_id              :integer
#  order_id             :integer
#  user_id              :integer
#  recurrence_rule      :string
#  recurrence_exception :string
#  recurrence_id        :integer
#  is_all_day           :boolean
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#

FactoryGirl.define do
  factory :event do
    start { Date.today + Faker::Number.between(7, 20).hours }
    self.end { start + Faker::Number.between(1, 3).hour }
    description ''
    is_all_day false
    area
    order
    user

    factory :past_event do
      start { Faker::Number.between(7, 20).days.ago }
    end

    factory :future_event do
      start { Date.today + Faker::Number.between(7, 20).days }
    end
  end
end
