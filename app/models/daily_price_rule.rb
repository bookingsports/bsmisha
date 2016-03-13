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

class DailyPriceRule < ActiveRecord::Base
  include DailyPriceRuleConcern
  has_paper_trail

  belongs_to :price
  validates :start, :stop, :value, presence: true

  default_scope ->{ order(created_at: :desc) }

  #def self.overlaps event
  #  DailyPriceRule.all.where('start::time <= ? or stop::time >= ?', event.start.utc.strftime('%H:%M'), event.stop.utc.strftime('%H:%M'))
  #end

  scope :overlaps, -> (event) do
    start = arel_table['start']
    stop = arel_table['stop']

    event_start = event.start.utc.strftime('%H:%M')
    event_stop = event.stop.utc.strftime('%H:%M')

    start.lteq(event_start).or(stop.lteq(event_stop))
  end

  def name
    "Правило цены с #{start} по #{stop}"
  end
end
