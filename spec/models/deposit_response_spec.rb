# == Schema Information
#
# Table name: deposit_responses
#
#  id                 :integer          not null, primary key
#  deposit_request_id :integer
#  status             :integer
#  data               :text
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#

require 'rails_helper'

RSpec.describe DepositResponse, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
