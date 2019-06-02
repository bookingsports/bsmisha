class OrderItem < ActiveRecord::Base
  belongs_to :event
  belongs_to :event_change
  belongs_to :group_event
  belongs_to :order

  validates :quantity, presence: true, numericality: { only_integer: true, greater_than: 0 }
  validate :order_present
  validate :product_present
  enum status: [:unconfirmed, :confirmed, :paid, :paid_approved, :canceled]

  before_save :finalize

  def unit_price
    if persisted?
      self[:unit_price]
    elsif event.present?
      event.price
    elsif group_event.present?
      group_event.price
    elseif
    end
  end

  def total_price
    unit_price * quantity
  end

  def update_status (status)
    if self.event.present?
      self.event.update status: status
    elsif self.group_event.present?
      self.group_event.update status: status
    elsif self.event_change.present?
      self.event_change.update status: status
    end
  end

  private
  def product_present
    if event.nil? && group_event.nil? && event_change.nil?
      errors.add(:order_item, "is not valid or is not active.")
    end
  end

  def order_present
    if order.nil?
      errors.add(:order, "is not a valid order.")
    end
  end

  def finalize
    self[:unit_price] = unit_price
    self[:total_price] = quantity * self[:unit_price]
  end
end
