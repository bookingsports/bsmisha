# == Schema Information
#
# Table name: daily_price_rules
#
#  id           :integer          not null, primary key
#  price_id     :integer
#  start        :string
#  stop         :string
#  price        :integer
#  working_days :integer          default([]), is an Array
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

class DailyPriceRule < ActiveRecord::Base
  include DailyPriceRuleConcern
  has_paper_trail

  belongs_to :price

  def name
    "Правило цены с #{start} по #{stop}"
  end
end
