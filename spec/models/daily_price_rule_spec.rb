# == Schema Information
#
# Table name: daily_price_rules
#
#  id           :integer          not null, primary key
#  price_id     :integer
#  start        :time
#  stop         :time
#  value        :integer
#  working_days :integer          default([]), is an Array
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

require 'rails_helper'

RSpec.describe DailyPriceRule do
  it 'should validate that stop greater than start by 30 min'
  it 'should validate step by 30 min'
end
