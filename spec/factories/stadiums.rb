# == Schema Information
#
# Table name: stadiums
#
#  id          :integer          not null, primary key
#  user_id     :integer
#  category_id :integer
#  name        :string           default("Без названия"), not null
#  phone       :string
#  description :string
#  address     :string
#  latitude    :float
#  longitude   :float
#  slug        :string
#  status      :integer          default(0)
#  email       :string
#  main_image  :string
#  opens_at    :time
#  closes_at   :time
#  created_at  :datetime
#  updated_at  :datetime
#

FactoryGirl.define do
  factory :stadium do
    category nil
    user
    name "MyString"
    phone "MyString"
    latitude 55.747655
    longitude 37.603513
    description "MyText"
  end
end
