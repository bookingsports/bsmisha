# == Schema Information
#
# Table name: event_changes
#
#  id         :integer          not null, primary key
#  event_id   :integer
#  order_id   :integer
#  old_start  :datetime
#  old_stop   :datetime
#  new_start  :datetime
#  new_stop   :datetime
#  old_price  :float
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class EventChange < ActiveRecord::Base
  include EventChangeConcern
  has_paper_trail

  belongs_to :event
  belongs_to :order

  scope :paid, -> { joins("LEFT OUTER JOIN orders ON orders.id = event_changes.order_id").where("orders.status =  ?", Order.statuses[:paid]) }
  scope :unpaid, -> { joins("LEFT OUTER JOIN orders ON orders.id = event_changes.order_id").where("orders.status =  ? or orders.status is null", Order.statuses[:unpaid]) }
  scope :past, -> { where arel_table['new_stop'].lt Time.now }
  scope :future, -> { where arel_table['new_start'].gt Time.now }
  scope :of_areas, ->(*areas) do
    joins(event: :events_areas).
    where(events_areas: {area_id: areas}).uniq
  end

  after_save :update_event

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
    fee_after_nine + calculate_new_price
  end

  def calculate_new_price
    event.price > new_price ? 0 : new_price - event.price
  end

  def fee_after_nine
    d = old_start - 1.day
    t = Time.zone.parse("21:00")
    pay_time = DateTime.new(d.year, d.month, d.day, t.hour, t.min, t.sec, t.zone)
    created_at.to_date > pay_time ? event.price * event.area.change_price.to_i / 100 : 0
  end

  def update_event
    if paid?
      event.update start: new_start, stop: new_stop
    end
  end
end
