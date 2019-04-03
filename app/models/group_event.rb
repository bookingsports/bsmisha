class GroupEvent < ActiveRecord::Base

  validates :start, :stop, :user_id, :area_id, presence: true

  validates :stop, greater_by_30_min: {than: :start}, allow_blank: true
  validates :start, :stop, step_by_30_min: true, allow_blank: true
  validate :start_is_not_in_the_past
  validates :max_count_participants, presence: true
  validate :not_overlaps_other_events
  validate :validate_guests_count

  belongs_to :user
  belongs_to :coach
  belongs_to :area

  has_many :event_guests
  accepts_nested_attributes_for :event_guests

  enum status: [:unconfirmed, :confirmed, :locked, :paid]

  scope :past, -> { where arel_table['stop'].lt Time.now }
  scope :future, -> { where arel_table['start'].gt Time.now }
  scope :unpaid, -> { where.not(status: Event.statuses["paid"])}
  scope :paid_or_confirmed, -> {
    GroupEvent.where(status: [GroupEvent.statuses[:paid], GroupEvent.statuses[:confirmed], GroupEvent.statuses[:locked], GroupEvent.statuses[:for_sale]])
  }
  scope :between, -> (start, stop) do
    table_start = arel_table['start']
    table_stop = arel_table['stop']

    table_start.gteq(start).and(table_start.lt(stop))
        .or(table_stop.gt(start).and(table_stop.lteq(stop)))
        .or(table_start.lt(start).and(table_stop.gt(stop)))
  end

  def validate_guests_count
    if self.event_guests.size > self.max_count_participants
      errors.add(:event_guests, "Максимальное количество участников в данной группе " + self.max_count_participants.to_s)
    end
  end

  def duration
    stop - start
  end

  def start_is_not_in_the_past
    if start.present? && start < Time.now
      errors.add(:start, "can't be in the past")
    end
  end

  def price_with_cur
    return price.to_s + " руб."

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
    GroupEvent.where(GroupEvent.between(start, stop))
        .where.not(id: id)
        .where(area_id: area_id)
        .present? || overlaps_individual_events?(start,stop)
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

  def overlaps_individual_events? start, stop
    Event.where(Event.between(start, stop))
        .where(user_id: user.id, area_id: area_id)
        .where.not(id: id)
        .union(Event.paid_or_confirmed.where(Event.between(start, stop))
        .where.not(id: id)
        .where(area_id: area_id))
        .present?
  end

  def convert_for_order
    hash = {pname: ["Комиссия BookingSports",self.name],
            pcode: [],
            price: [],
            order_qty: [1,1],
            order_vat: [0,0],
            order_mplace_merchant: [Rails.application.secrets.merchant_st, self.area.stadium.account.merchant_id] }
    #данные по комисси сервиса BS
    hash[:pcode].push(self.id.to_s + "_com")
    hash[:price].push(self.price*Rails.application.secrets.tax.to_f/100)
    #данные по стадиону
    hash[:pcode].push(self.id.to_s)
    hash[:price].push((self.price)*(1.0 - Rails.application.secrets.tax.to_f/100))
    #данные по услугам тренера
    # TODO: Продумать сколько и как переводить тренеру
=begin
    if !self.coach_id.blank?
      hash[:pname].push("Услуги тренера #{self.coach.name} на стадионе #{self.area.name_with_stadium} #{start.strftime("%d.%m.%Y")} с #{start.strftime("%I:%M")} до #{stop.strftime("%I:%M")}")
      hash[:pcode].push(self.id.to_s + "_" + self.coach_id.to_s)
      hash[:price].push(self.coach_price*(1.0 - Rails.application.secrets.tax.to_f/100))
      hash[:order_qty].push(1)
      hash[:order_vat].push(0)
      hash[:order_mplace_merchant].push(self.coach.account.merchant_id.blank? ? self.area.stadium.account.merchant_id : self.coach.account.merchant_id)
    end
=end
    return hash
  end

end
