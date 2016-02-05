# == Schema Information
#
# Table name: static_pages
#
#  id         :integer          not null, primary key
#  text       :text
#  title      :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  slug       :string
#

FactoryGirl.define do
  factory :static_page do
    text "MyText"
    title "MyString"
  end
end
