class Event < ActiveRecord::Base
  include Changeable
  belongs_to :order
  has_and_belongs_to_many :products
  has_and_belongs_to_many :product_services # , dependent: :destroy - not sure
  has_many :additional_event_items, dependent: :destroy
  belongs_to :user

  attr_reader :schedule

  scope :paid, -> { joins("LEFT OUTER JOIN orders ON orders.id = events.order_id").where("orders.status =  ?", Order.statuses[:paid]) }
  scope :unpaid, -> { joins("LEFT OUTER JOIN orders ON orders.id = events.order_id").where("orders.status =  ? or orders.status is null", Order.statuses[:unpaid]) }
  scope :past, -> { where('"end" < ?', Time.current)}
  scope :future, -> { where('"start" > ?', Time.current)}
  scope :paid_or_owned_by,  -> (user) do
    if user
      joins("LEFT OUTER JOIN orders ON orders.id = events.order_id").where("(orders.user_id <> :id and orders.status = :st) or events.user_id = :id ", { id: user.id, st: Order.statuses[:paid]} )
    else
      paid
    end
  end
  scope :of_products, ->(*products) do
    joins(:events_products).where(events_products: { product_id: products.flatten.map(&:id) }).uniq
  end

  after_initialize :build_schedule

  def description
    attributes["description"] || ""
  end

  def total
    associated_payables_with_price.map {|p| p[:total] }.inject(&:+)
  end

  def associated_payables
    (products + product_services)
  end

  def associated_payables_with_price
    associated_payables.map {|p| {product: p, total: p.price_for_event(self) * occurrences}}
  end

  def duration_in_hours
    (duration / 1.hour).ceil * occurrences
  end

  def duration
    self.end - self.start
  end

  def hours
    arr = (self.start.hour..self.end.hour).to_a
    if self.end.min == 0
      arr[0..-2]
    else
      arr
    end
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

  def product_names
    products.map(&:name).join(', ')
  end

  def coaches
    products.where(type: "Coach")
  end

  def coach
    coaches.first
  end

  def stadium
    products.where(type: "Stadium").first || court.try(:stadium) || Stadium.new
  end

  def courts
    products.where(type: "Court")
  end

  def court
    courts.first || Court.new
  end

  private

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
