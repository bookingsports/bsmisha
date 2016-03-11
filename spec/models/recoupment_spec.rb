# == Schema Information
#
# Table name: recoupments
#
#  id         :integer          not null, primary key
#  duration   :integer
#  user_id    :integer
#  area_id    :integer
#  reason     :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'rails_helper'

RSpec.describe Recoupment, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
