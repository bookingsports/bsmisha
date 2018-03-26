class GroupEvent < ActiveRecord::Base

  validates :start, :stop, :user_id, :area_id, presence: true

  validates :stop, greater_by_30_min: {than: :start}, allow_blank: true
  validates :start, :stop, step_by_30_min: true, allow_blank: true
  validate :start_is_not_in_the_past


  belongs_to :user
  belongs_to :coach
  belongs_to :area

  has_many :event_guests
  accepts_nested_attributes_for :event_guests

  def start_is_not_in_the_past
    if start.present? && start < Time.now
      errors.add(:start, "can't be in the past")
    end
  end

  def recurring?
    recurrence_rule.present?
  end

  def self.scoped_by options
    if options[:scope] != "grid" || (options[:user].present? && options[:user].type != "Customer")
      events = GroupEvent.all
      options[:area] && (events = events.where(area: options[:area]))
      options[:coach] && (events = events.where(coach: options[:coach]))
    end

    if options[:user].present?
      user_events = options[:user].group_events
      options[:area] && (user_events = user_events.where(area: options[:area]))
      options[:coach] && (user_events = user_events.where(coach: options[:coach]))
    end

    if !options[:user].present? && options[:area].present?
      events = GroupEvent.all
      events = events.where(area: options[:area])
    end

    if events.present? && user_events.present?
      events = events.union(user_events)
    elsif user_events.present?
      events = user_events
    elsif events.blank? && user_events.blank?
      events = GroupEvent.none
    end
    events = events.includes(:area, :coach, :user)
    events
  end

  def overlaps? start, stop
    Event.where(Event.between(start, stop))
        .where(user_id: user.id, area_id: area_id)
        .where.not(id: id)
        .union(Event.paid_or_confirmed.where(Event.between(start, stop))
                   .where.not(id: id)
                   .where(area_id: area_id))
        .present?
  end

  def has_at_least_one_occurrence
    build_schedule
    if @schedule.all_occurrences.count <= 0
      errors.add(:recurrence_rule, "doesn't have any occurrences")
    end
  end

  def not_overlaps_other_events
    if start.present? && stop.present? && !recurring? && overlaps?(start, stop)
      errors.add(:base, 'Данное занятие накладывается на другое оплаченное или забронированное занятие')
    elsif start.present? && stop.present?
      build_schedule
      @schedule.all_occurrences.each do |e|
        if overlaps?(e, e + duration)
          errors.add(:base, 'Данное занятие накладывается на другое оплаченное или забронированное занятие')
        end
      end
    end
  end

  def build_schedule
    puts "in build_schedule"
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
