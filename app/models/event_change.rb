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
  belongs_to :event
  belongs_to :order

  scope :paid, -> { joins("LEFT OUTER JOIN orders ON orders.id = event_changes.order_id").where("orders.status =  ?", Order.statuses[:paid]) }
  scope :unpaid, -> { joins("LEFT OUTER JOIN orders ON orders.id = event_changes.order_id").where("orders.status =  ? or orders.status is null", Order.statuses[:unpaid]) }
  scope :of_products, ->(*products) do
    joins(event: :events_products).
    where(events_products: {product_id: products}).uniq
  end

  delegate :products, to: :event

  def total
    event.court.change_price.to_i
  end
end
