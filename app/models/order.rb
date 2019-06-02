class Order < ActiveRecord::Base
  has_many :order_items
  has_many :events, :through => :order_items
  has_many :group_events, :through => :order_items
  has_many :event_changes, :through => :order_items

  before_save :update_subtotal

  enum status: [:unconfirmed, :confirmed, :paid, :paid_approved, :canceled]

  def subtotal
    order_items.collect { |oi| oi.valid? ? (oi.quantity * oi.unit_price) : 0 }.sum
  end

  def update_status (status)
    self.update status: status
    self.order_items.each{|e| e.update_status(status)}
  end
  private

  def update_subtotal
    self[:subtotal] = subtotal
  end
end