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

  scope :overlaps, -> (event) do
    start = arel_table['start']
    stop = arel_table['stop']

    event_start = event.start.utc.strftime('%H:%M')
    event_stop = event.stop.utc.strftime('%H:%M')

    start.gteq(event_start).and(start.lt(event_stop))\
    .or(stop.gt(event_start).and(stop.lteq(event_stop)))\
    .or(start.lt(event_start).and(stop.gt(event_stop)))
  end

  def name
    "Правило цены с #{start} по #{stop}"
  end
end
