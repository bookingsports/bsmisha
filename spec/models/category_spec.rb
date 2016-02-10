# == Schema Information
#
# Table name: categories
#
#  id         :integer          not null, primary key
#  name       :string
#  ancestry   :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  slug       :string
#  icon       :string
#  position   :integer
#

require 'rails_helper'

RSpec.describe Category, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
