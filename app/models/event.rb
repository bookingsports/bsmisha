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
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#

class Event < ActiveRecord::Base
  include EventConcern

  has_paper_trail

  validates :start, :stop, :order_id, :user_id, :area_id, presence: true
  validate :stop_greater_than_start, :start_is_not_in_the_past, :step_by_30_min, unless: 'start.blank? or stop.blank?'

  belongs_to :user
  belongs_to :order

  belongs_to :coach
  belongs_to :area

  has_many :event_changes, -> { order(created_at: :desc) }, dependent: :destroy
  has_many :additional_event_items, dependent: :destroy

  #has_many :special_prices, -> {
  #  where("('start' >= :event_start AND 'start < :event_stop) OR ('stop' > :event_start AND 'stop' <= #:event_stop) OR ('start' < :event_start AND 'stop' > :event_stop)", event_start: start, event_stop: stop)
  #}, through: :area

  has_and_belongs_to_many :stadium_services

  attr_reader :schedule

  scope :paid_or_owned_by, -> (user) do
    joins(:order).where order_is(:paid).or arel_table['user_id'].eq user.id
  end

  scope :paid, -> { joins(:order).where order_is :paid }
  scope :unpaid, -> { joins(:order).where order_is :unpaid }

  scope :past, -> { where arel_table['stop'].lt Time.now }
  scope :future, -> { where arel_table['start'].gt Time.now }

  after_initialize :build_schedule

  def name
    "Событие с #{start} по #{stop}"
  end

  def total
    associated_payables_with_price.map {|p| p[:total] }.inject(&:+)
  end

  def associated_payables
    ([area] + stadium_services)
  end

  def associated_payables_with_price
    associated_payables.map {|p| {product: p, total: p.price_for_event(self) * occurrences}}
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
    when self.user == user && has_unpaid_changes?
      "has_unpaid_changes"
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
    event_changes.unpaid.present?
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

  private
    def self.order_is(status)
      Order.arel_table['status'].eq(Order.statuses[status])
    end

    def stop_greater_than_start
      if stop - start < 30.minutes
        errors.add(:stop, "can't be less than start at least 30 min.")
      end
    end

    def start_is_not_in_the_past
      if start < Time.now
        errors.add(:start, "can't be in the past")
      end
    end

    def step_by_30_min
      [:start, :stop].each do |time|
        if self[time].min % 30 != 0
          errors.add(time, 'minutes can be only 30 or 0')
        end
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
