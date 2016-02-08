# == Schema Information
#
# Table name: orders
#
#  id         :integer          not null, primary key
#  user_id    :integer
#  total      :decimal(8, 2)
#  status     :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  comment    :string
#

FactoryGirl.define do
  factory :order do
    user nil
    total ""
    total ""
    status 1
  end
end
