# == Schema Information
#
# Table name: users
#
#  id                     :integer          not null, primary key
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  reset_password_token   :string
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer          default(0), not null
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :inet
#  last_sign_in_ip        :inet
#  name                   :string
#  type                   :string           default("Customer")
#  avatar                 :string
#  status                 :integer          default(0)
#  phone                  :string
#  created_at             :datetime
#  updated_at             :datetime
#

FactoryGirl.define do
  factory :user, class: 'Customer' do
    avatar { Faker::Avatar.image }
    name { Faker::Name.name }
    email { Faker::Internet.email }
    password { Faker::Internet.password }
    phone { Faker::PhoneNumber.cell_phone }

    factory :customer, class: 'Customer'
    factory :coach_user, class: 'CoachUser'
    factory :admin, class: 'Admin'

    factory :stadium_user, class: 'StadiumUser' do
      status :active
    end
  end
end
