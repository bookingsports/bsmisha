# == Schema Information
#
# Table name: accounts
#
#  id         :integer          not null, primary key
#  number     :string
#  company    :string
#  inn        :string
#  kpp        :string
#  bank       :string
#  bank_city  :string
#  bik        :string
#  kor        :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Account < ActiveRecord::Base
  include AccountConcern
end
