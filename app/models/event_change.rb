# == Schema Information
#
# Table name: event_changes
#
#  id         :integer          not null, primary key
#  event_id   :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  status     :integer
#  summary    :string
#  order_id   :integer
#

class EventChange < ActiveRecord::Base
  include EventChangeConcern
  has_paper_trail

  belongs_to :event
  belongs_to :order

  scope :paid, -> { joins("LEFT OUTER JOIN orders ON orders.id = event_changes.order_id").where("orders.status =  ?", Order.statuses[:paid]) }
  scope :unpaid, -> { joins("LEFT OUTER JOIN orders ON orders.id = event_changes.order_id").where("orders.status =  ? or orders.status is null", Order.statuses[:unpaid]) }
  scope :of_products, ->(*products) do
    joins(event: :events_products).
    where(events_products: {product_id: products}).uniq
  end

  def paid?
    order.present? && order.paid?
  end

  def unpaid?
    !paid?
  end

  def name
    "Изменение #{id} #{event_id.present? ? "события №" + event_id.to_s : ""} "
  end

  def total
    d = event.start - 1.day
    t = Time.zone.parse("21:00")
    pay_time = DateTime.new(d.year, d.month, d.day, t.hour, t.min, t.sec, t.zone)
    created_at.to_date > pay_time ? event.area.change_price.to_i : 0
  end
end
