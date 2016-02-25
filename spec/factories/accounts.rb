# == Schema Information
#
# Table name: accounts
#
#  id               :integer          not null, primary key
#  number           :string
#  company          :string
#  inn              :string
#  kpp              :string
#  bik              :string
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  accountable_type :string
#  accountable_id   :integer
#  agreement_number :string
#  date             :datetime
#

FactoryGirl.define do
  factory :account do
    number "MyString"
    company "MyString"
    inn=string "MyString"
    kpp "MyString"
    bank "MyString"
    bank_city "MyString"
    bik "MyString"
    kor "MyString"
  end
end
