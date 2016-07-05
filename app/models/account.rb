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

class Account < ActiveRecord::Base
  include AccountConcern
  belongs_to :accountable, polymorphic: true
  has_paper_trail

  def name
    "Реквизиты #{accountable.name}"
  end
end
