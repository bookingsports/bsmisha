# == Schema Information
#
# Table name: events
#
#  id                   :integer          not null, primary key
#  start                :datetime
#  end                  :datetime
#  description          :string
#  order_id             :integer
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#  recurrence_rule      :string
#  recurrence_exception :string
#  recurrence_id        :integer
#  is_all_day           :boolean
#  user_id              :integer
#  product_id           :integer
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
