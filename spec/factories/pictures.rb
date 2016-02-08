# == Schema Information
#
# Table name: pictures
#
#  id             :integer          not null, primary key
#  name           :string
#  imageable_id   :integer
#  imageable_type :string
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  description    :string
#

FactoryGirl.define do
  factory :picture do
    name "MyString"
    references ""
  end
end
