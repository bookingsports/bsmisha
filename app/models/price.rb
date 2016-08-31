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

  validates :area_id, :start, :stop, :daily_price_rules, presence: true
  validates :stop, greater_by_30_min: {than: :start}, allow_blank: true
  validates :start, :stop, step_by_30_min: true, allow_blank: true
  validate :prices_overlap

  accepts_nested_attributes_for :daily_price_rules, reject_if: :all_blank, allow_destroy: true

  around_save :validate_price_rules_overlapping

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

  def overlaps?(event)
    (start >= event.start && start < stop) \
    || (stop > event.start && stop <= event.stop) \
    || (start < event.start && stop > event.stop)
  end

  # return value for current time
  scope :current, -> do
    where('LOCALTIMESTAMP BETWEEN "start" AND "stop"').last
  end

  def name
    "Период с #{start} по #{stop}"
  end

  def daily_price_rules_overlap?
    return false if errors.present?
    daily_price_rules.each do |d|
      return true if d.overlaps_others?
    end
    return false
  end

  private
    def prices_overlap
      return false if errors.present?
      if area.prices.where(Price.between(start, stop)).where.not(id: id).present?
        errors.add(:base, "Периоды накладываются друг на друга.")
      end
    end

    def validate_price_rules_overlapping
      yield
      if daily_price_rules_overlap?
        errors.add(:base, 'Правила накладываются друг на друга')
        raise ActiveRecord::Rollback
      end
    end
end
