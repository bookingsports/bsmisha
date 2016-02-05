# == Schema Information
#
# Table name: product_services
#
#  id         :integer          not null, primary key
#  product_id :integer
#  service_id :integer
#  price      :decimal(8, 2)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  type       :string
#

require 'rails_helper'

RSpec.describe ProductService, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
