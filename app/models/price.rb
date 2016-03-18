# == Schema Information
#
# Table name: prices
#
#  id         :integer          not null, primary key
#  start      :datetime
#  stop       :datetime
#  area_id    :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Price < ActiveRecord::Base
  include PriceConcern

  has_paper_trail

  belongs_to :area
  has_many :daily_price_rules, dependent: :destroy

  validates :area_id, :start, :stop, presence: true
  validates :stop, greater_by_30_min: {than: :start}, allow_blank: true
  validates :start, :stop, step_by_30_min: true, allow_blank: true

  after_create { daily_price_rules.create }

  accepts_nested_attributes_for :daily_price_rules

  scope :overlaps, -> (event) do
    start = arel_table['start']
    stop = arel_table['stop']

    start.gteq(event.start).and(start.lt(event.stop))\
    .or(stop.gt(event.start).and(stop.lteq(event.stop)))\
    .or(start.lt(event.start).and(stop.gt(event.stop)))
  end

  scope :between, -> (start, stop) do
    table_start = arel_table['start']
    table_stop = arel_table['stop']

    table_start.gteq(start).and(table_start.lt(stop))\
    .or(table_stop.gt(start).and(table_stop.lteq(stop)))\
    .or(table_start.lt(start).and(table_stop.gt(stop)))
  end

  # return value for current time
  scope :current, -> do
    where('LOCALTIMESTAMP BETWEEN "start" AND "stop"').last || new
  end

  def name
    "Период с #{start} по #{stop}"
  end
end