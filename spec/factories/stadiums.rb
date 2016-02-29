# == Schema Information
#
# Table name: stadiums
#
#  id          :integer          not null, primary key
#  user_id     :integer
#  name        :string
#  phone       :string
#  description :string
#  address     :string
#  latitude    :float
#  longitude   :float
#  slug        :string
#  status      :integer
#  email       :string
#  avatar      :string
#  opens_at    :time
#  closes_at   :time
#

FactoryGirl.define do
  factory :stadium do
    category nil
    user nil
    name "MyString"
    phone "MyString"
    latitude 55.747655
    longitude 37.603513
    description "MyText"
  end
end
