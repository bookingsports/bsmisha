# == Schema Information
#
# Table name: options
#
#  id             :integer          not null, primary key
#  tax            :integer          default(5)
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  feedback_email :string
#

FactoryGirl.define do
  factory :option do
    tax 1
  end
end
