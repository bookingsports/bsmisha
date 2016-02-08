# == Schema Information
#
# Table name: withdrawal_requests
#
#  id         :integer          not null, primary key
#  wallet_id  :integer
#  status     :integer
#  amount     :decimal(8, 2)
#  data       :text
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'rails_helper'

RSpec.describe WithdrawalRequest, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
