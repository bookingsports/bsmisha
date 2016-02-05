# == Schema Information
#
# Table name: daily_price_rules
#
#  id               :integer          not null, primary key
#  special_price_id :integer
#  start            :string
#  stop             :string
#  price            :integer
#  working_days     :integer          default([]), is an Array
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#

require 'rails_helper'

RSpec.describe DailyPriceRule, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
