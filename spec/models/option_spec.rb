# == Schema Information
#
# Table name: options
#
#  id             :integer          not null, primary key
#  tax            :integer          default(5)
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  feedback_email :string
#

require 'rails_helper'

RSpec.describe Option, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
