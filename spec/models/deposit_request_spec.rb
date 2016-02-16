# == Schema Information
#
# Table name: deposit_requests
#
#  id         :integer          not null, primary key
#  wallet_id  :integer
#  status     :integer
#  amount     :decimal(8, 2)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  data       :text
#  uuid       :string
#

require 'rails_helper'

RSpec.describe DepositRequest, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
