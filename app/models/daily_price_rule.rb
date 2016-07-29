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
  validate :working_days_not_empty
  validate :start_and_stop_stadium_hours
  before_save :fix_working_days

  after_save :update_counter_cache
  after_destroy :update_counter_cache

  default_scope ->{ order(created_at: :desc) }

  scope :overlaps, -> (event) do
    start = arel_table['start']
    stop = arel_table['stop']

    event_start = event.start.strftime('%H:%M')
    event_stop = event.stop.strftime('%H:%M')

    arel_table['working_days'].any(event.wday)
    .and(start.gteq(event_start).and(start.lt(event_stop))
    .or(stop.gt(event_start).and(stop.lteq(event_stop)))
    .or(start.lt(event_start).and(stop.gt(event_stop))))
  end

  def overlaps? event
    self_start = start.strftime("%H%M%S%N")
    self_stop = stop.strftime("%H%M%S%N")
    event_start = event.start.strftime("%H%M%S%N")
    event_stop = event.stop.strftime("%H%M%S%N")

    working_days.include?(event.wday) \
    && ((self_start >= event_start && self_start < event_stop) \
      || (self_stop > event_start && self_stop <= event_stop) \
      || (self_start < event_start && self_stop > event_stop))
  end

  scope :between, -> (start, stop) do
    table_start = arel_table['start']
    table_stop = arel_table['stop']

    date_start = start.strftime('%H:%M')
    date_stop = stop.strftime('%H:%M')

    arel_table['working_days'].any(start.wday)
    .and(table_start.gteq(date_start).and(table_start.lt(date_stop))
    .or(table_stop.gt(date_start).and(table_stop.lteq(date_stop)))
    .or(table_start.lt(date_start).and(table_stop.gt(date_stop))))
  end

  def name
    "Правило цены с #{start} по #{stop}"
  end

  def overlaps_others?
    return if errors.any?
    date_start = start.strftime('%H:%M')
    date_stop = stop.strftime('%H:%M')

    price.daily_price_rules
    .where('(start >= :start and start < :stop) or (stop > :start and stop <= :stop) or (start < :start and stop > :stop)', {start: date_start, stop: date_stop} )
    .where.not(id: id)
    .select {|p| (p.working_days & working_days).compact.present? }
    .present?
  end

  def time_for_event e
    d = Time.new
    event_start = Time.new(d.year, d.month, d.day, e.start.hour, e.start.min, e.start.sec)
    event_stop = Time.new(d.year, d.month, d.day, e.stop.hour, e.stop.min, e.stop.sec)
    price_start = Time.new(d.year, d.month, d.day, start.hour, start.min, start.sec)
    price_stop = Time.new(d.year, d.month, d.day, stop.hour, stop.min, stop.sec)

    price = 0
    if price_start <= event_start && price_stop <= event_stop
      price = price_stop - event_start
    elsif price_stop >= event_stop && price_start >= event_start
      price = event_stop - price_start
    elsif price_start <= event_start && price_stop >= event_stop
      price = event_stop - event_start
    end
    price / 1.hour
  end

  def update_counter_cache
    if self.price.area.stadium.daily_price_rules.any?
      self.price.area.stadium.lowest_price = self.price.area.stadium.daily_price_rules.reorder('value asc').first.value
      self.price.area.stadium.highest_price = self.price.area.stadium.daily_price_rules.reorder('value desc').first.value
      self.price.area.stadium.save
    end
  end

  private
    def working_days_not_empty
      if working_days.compact.empty?
        errors.add(:working_days, "can't be empty")
      end
    end

    def fix_working_days
      working_days.compact!
    end

    def start_and_stop_stadium_hours
      return if errors.any? || price.blank? || price.area.stadium.opens_at.blank? || price.area.stadium.opens_at.blank?
      if start.utc.strftime( "%H%M%S%N" ) < price.area.stadium.opens_at.utc.strftime( "%H%M%S%N" )
        errors.add(:start, "не может быть меньше, чем время открытие стадиона")
      end
      if stop.utc.strftime( "%H%M%S%N" ) > price.area.stadium.closes_at.utc.strftime( "%H%M%S%N" )
        errors.add(:stop, "не может быть больше, чем время закрытия стадиона")
      end
    end
end

