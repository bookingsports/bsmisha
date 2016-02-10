# == Schema Information
#
# Table name: categories
#
#  id         :integer          not null, primary key
#  name       :string
#  ancestry   :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  slug       :string
#  icon       :string
#  position   :integer
#

FactoryGirl.define do
  factory :category do
    name "MyString"
  end
end
