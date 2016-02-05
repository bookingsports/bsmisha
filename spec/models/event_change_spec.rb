# == Schema Information
#
# Table name: event_changes
#
#  id         :integer          not null, primary key
#  event_id   :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  status     :integer
#  summary    :string
#  order_id   :integer
#

require 'rails_helper'

RSpec.describe EventChange, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
