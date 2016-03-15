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

  has_paper_trail

  validates :start, :stop, :user_id, :area_id, presence: true

  validates :stop, greater_by_30_min: {than: :start}, allow_blank: true
  validates :start, :stop, step_by_30_min: true, allow_blank: true
  validate :start_is_not_in_the_past

  belongs_to :user
  belongs_to :order

  belongs_to :coach
  belongs_to :area

  has_one :event_change, dependent: :destroy
  has_many :additional_event_items, dependent: :destroy

  has_many :prices, -> (event) { where Price.overlaps event }, through: :area
  has_many :daily_price_rules, -> (event) { where DailyPriceRule.overlaps event }, through: :prices

  has_and_belongs_to_many :stadium_services

  enum status: [:active, :cancelled]

  attr_reader :schedule

  scope :paid_or_owned_by, -> (user) do
    joins(:order).where order_is(:paid).or arel_table['user_id'].eq user.id
  end

  scope :paid, -> { joins(:order).where order_is :paid }
  scope :past, -> { where arel_table['stop'].lt Time.now }
  scope :future, -> { where arel_table['start'].gt Time.now }
  scope :unpaid, -> {
    where(order_id: nil).all
  }

  #scope :unpaid, -> {
  #  _events = find_by_sql(joins(:order).on(arel_table['order_id'].eq(nil).or(Order.arel_table['id'].eq(arel_table['order_id'])))
  #  .where(Order.arel_table['status'].eq(Order.statuses[:unpaid]).or(arel_table['order_id'].eq(nil))).to_sql)

  #  where(id: _events.map(&:id))
  #}

  after_initialize :build_schedule
  after_update :create_recoupment_if_cancelled
  before_update :create_event_change_if_not_present, if: "start_changed? && stop_changed?"

  def name
    "Событие с #{start} по #{stop}"
  end

  def price
    area_price + stadium_services_price + coach_price
  end

  def wday
    start.wday == 0 ? 7 : start.wday
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

  def visual_type_for user
    case
    when self.paid?
      "paid"
    when self.user == user
      "owned"
    else
      "disowned"
    end
  end

  def paid?
    order && order.paid?
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

  def start_before_change
    event_before_change ? Time.zone.parse(event_before_change["start"]) : attributes["start"]
  end

  def end_before_change
    event_before_change ? Time.zone.parse(event_before_change["stop"]) : attributes["stop"]
  end

  def event_before_change
    @event_before_change ||= JSON.parse(event_changes.unpaid.last.summary) if event_changes.unpaid.last
  end

  def stadium_services_price
    stadium_services.map{|ss| ss.price_for_event(self)}.inject(:+) || 0
  end

  def coach_price
    coach.present? ? coach.coaches_areas.where(area: area).first.price * duration_in_hours : 0
  end

  def area_price
    daily_price_rules.sum(:value) * duration_in_hours * occurrences
  end

  private
    def create_event_change_if_not_present
      if unpaid?
        return true
      elsif event_change.present?
        return false
      else
        create_event_change
      end
    end

    def create_recoupment_if_cancelled
      if cancelled?
        if user.recoupments.where(area: self.area).any?
          rec = user.recoupments.where(area: self.area).first
          rec.update duration: rec.duration + self.duration
        else
          Recoupment.create user: self.user, duration: self.duration, area: self.area
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

    def build_schedule
      @schedule = IceCube::Schedule.new do |s|
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
