# == Schema Information
#
# Table name: reviews
#
#  id              :integer          not null, primary key
#  reviewable_id   :integer
#  reviewable_type :string
#  text            :text
#  user_id         :integer
#  verified        :boolean
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  rating          :integer
#

FactoryGirl.define do
  factory :review do
    reviewable nil
    text "MyText"
    user nil
    verified false
  end
end
