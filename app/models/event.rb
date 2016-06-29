# == Schema Information
#
# Table name: events
#
#  id                   :integer          not null, primary key
#  start                :datetime
#  stop                 :datetime
#  description          :string
#  coach_id             :integer
#  area_id              :integer
#  order_id             :integer
#  user_id              :integer
#  price                :float
#  recurrence_rule      :string
#  recurrence_exception :string
#  recurrence_id        :integer
#  is_all_day           :boolean
#  status               :integer          default(0)
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#

class Event < ActiveRecord::Base
  include EventConcern
  include ActiveModel::Dirty
  has_paper_trail

  validates :start, :stop, :user_id, :area_id, presence: true

  validates :stop, greater_by_30_min: {than: :start}, allow_blank: true
  validates :start, :stop, step_by_30_min: true, allow_blank: true
  validate :start_is_not_in_the_past
  validate :not_overlaps_other_events
  validate :has_at_least_one_occurrence

  belongs_to :user
  belongs_to :order

  belongs_to :coach
  belongs_to :area

  has_one :event_change, dependent: :destroy
  has_many :additional_event_items, dependent: :destroy

  has_many :prices, -> (event) { where Price.overlaps event }, through: :area
  has_many :daily_price_rules, -> (event) { where DailyPriceRule.overlaps event }, through: :prices

  has_and_belongs_to_many :stadium_services
  accepts_nested_attributes_for :stadium_services

  enum status: [:unconfirmed, :confirmed, :locked, :for_sale]

  attr_reader :schedule

  scope :paid_or_owned_by, -> (user) do
    joins(:order).where order_is(:paid).or arel_table['user_id'].eq user.id
  end

  scope :paid, -> { joins(:order).where order_is :paid }
  scope :past, -> { where arel_table['stop'].lt Time.now }
  scope :future, -> { where arel_table['start'].gt Time.now }
  scope :unpaid, -> {
    Event.where(order_id: nil).union(Event.joins(:order).where(orders: {status: Order.statuses[:unpaid]}))
  }
  scope :paid_or_confirmed, -> {
    Event.paid.union(Event.confirmed).union(Event.locked).uniq
  }
  scope :between, -> (start, stop) do
    table_start = arel_table['start']
    table_stop = arel_table['stop']

    table_start.gteq(start).and(table_start.lt(stop))
    .or(table_stop.gt(start).and(table_stop.lteq(stop)))
    .or(table_start.lt(start).and(table_stop.gt(stop)))
  end

  #scope :unpaid, -> {
  #  _events = find_by_sql(joins(:order).on(arel_table['order_id'].eq(nil).or(Order.arel_table['id'].eq(arel_table['order_id'])))
  #  .where(Order.arel_table['status'].eq(Order.statuses[:unpaid]).or(arel_table['order_id'].eq(nil))).to_sql)

  #  where(id: _events.map(&:id))
  #}

  after_initialize :build_schedule
  before_destroy :create_recoupment_if_cancelled
  before_update :create_event_change_if_not_present, if: "start_changed? && stop_changed?"
  after_save do
    update_columns("price" =>  area_price + stadium_services_price + coach_price)
  end

  def name
    "Событие с #{start} по #{stop}"
  end

  def wday
    start.wday
  end

  def duration_in_hours
    duration / 1.hour
  end

  def duration
    stop - start
  end

  def occurrences
    return 1 unless recurring?
    build_schedule
    if @schedule.terminating?
      @schedule.all_occurrences.length
    else
      @schedule.occurrences(Time.current + 1.month).length
    end
  end

  def all_occurrences
    return [] unless recurring?
    build_schedule
    @schedule.all_occurrences
  end

  def visual_type_for user
    case
    when self.locked?
      "locked"
    when self.for_sale?
      "for_sale"
    when self.user != user
      "disowned"
    when self.has_unpaid_changes?
      "has_unpaid_changes"
    when self.has_paid_changes?
      "has_paid_changes"
    when self.paid?
      "paid"
    when self.confirmed?
      "confirmed"
    when self.user == user
      "owned"
    end
  end

  def paid?
    order.present? && order.paid?
  end

  def recurring?
    recurrence_rule.present?
  end

  def unpaid?
    !paid?
  end

  def start_for(user)
    if self.user == user
      self.start
    else
      start_before_change
    end
  end

  def stop_for(user)
    if self.user == user
      stop
    else
      end_before_change
    end
  end

  def has_unpaid_changes?
    event_change.present? && event_change.unpaid?
  end

  def has_paid_changes?
    event_change.present? && event_change.paid?
  end

  def start_before_change
    has_unpaid_changes? ? event_change.old_start : attributes["start"]
  end

  def end_before_change
    has_unpaid_changes?  ? event_change.old_stop : attributes["stop"]
  end

  def stadium_services_price
    stadium_services.map{|ss| ss.price_for_event(self) * occurrences}.inject(:+) || 0
  end

  def coach_price
    coach.present? ? coach.coaches_areas.where(area: area).first.price * duration_in_hours * occurrences : 0
  end

  def area_price
    if recurring?
      build_schedule
      @schedule.all_occurrences.map{|e| prices_for_time(e, e + duration).map{|p| p.time_for_event(self) * p.value}.sum}.sum
    else
      daily_price_rules.map{|p| p.time_for_event(self) * p.value}.sum
    end
  end

  def coach_stadium_price
    coach_price * coach.coaches_areas.where(area: area).first.stadium_percent / 100
  end

  def coach_percent_price
    coach_price * (100 - coach.coaches_areas.where(area: area).first.stadium_percent) / 100
  end

  def prices_for_time start, stop
    prices = area.prices.where(Price.between start, stop)
    daily_price_rules = prices.first.daily_price_rules.where(DailyPriceRule.between start, stop)
  end

  def overlaps? start, stop
    Event.where(Event.between(start, stop))
          .where(user_id: user.id)
          .where.not(id: id)
          .where(area_id: area_id)
          .union(Event.paid_or_confirmed.where(Event.between(start, stop))
          .where.not(id: id)
          .where(area_id: area_id))
          .present?
  end

  def past?
    stop < Time.now
  end

  def future?
    start > Time.now
  end

  def qrcode_content
    "№#{id}, Date: #{start}, Sum: #{price.to_s} rub."
  end

  private
    def create_event_change_if_not_present
      if unpaid?
        return true
      elsif event_change.present? && event_change.unpaid?
        event_change.update new_start: start, new_stop: stop
      elsif event_change.present? && event_change.paid?
        return false
      elsif event_change.blank?
        create_event_change old_start: start_was, old_stop: stop_was, new_start: start, new_stop: stop, old_price: price
      end
    end

    def create_recoupment_if_cancelled
      if paid?
        if user.recoupments.where(area: self.area).any?
          rec = user.recoupments.where(area: self.area).first
          rec.update price: rec.price + self.price
        else
          Recoupment.create user: self.user, price: self.price, area: self.area
        end
      end
    end

    def self.order_is(status)
      Order.arel_table['status'].eq(Order.statuses[status])
    end

    def start_is_not_in_the_past
      if start.present? && start < Time.now
        errors.add(:start, "can't be in the past")
      end
    end

    def has_at_least_one_occurrence
      build_schedule
      if @schedule.all_occurrences.count <= 0
        errors.add(:recurrence_rule, "doesn't have any occurrences")
      end
    end

    def not_overlaps_other_events
      if start.present? && stop.present? && !recurring? && overlaps?(start, stop)
        errors.add(:event, 'overlaps other event')
      elsif start.present? && stop.present?
        build_schedule
        @schedule.all_occurrences.each do |e|
          if overlaps?(e, e + duration)
            errors.add(:event, 'overlaps other event')
          end
        end
      end
    end

    def build_schedule
      @schedule = IceCube::Schedule.new start do |s|
        if recurring?
          s.add_recurrence_rule(IceCube::Rule.from_ical(recurrence_rule))
          if recurrence_exception.present? && recurrence_exception =~ /=/
            s.add_exception_rule(IceCube::Rule.from_ical(recurrence_exception))
          end
        else
          s.add_recurrence_rule(IceCube::SingleOccurrenceRule.new start)
        end
      end
    end
end
