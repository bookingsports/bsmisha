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

class DailyPriceRule < ActiveRecord::Base
  has_paper_trail
  
  belongs_to :special_price

  def start=(val)
    string = val.kind_of?(String) ? val : val.values.join(":")
    super(string)
  end

  def stop=(val)
    string = val.kind_of?(String) ? val : val.values.join(":")
    super(string)
  end
end
