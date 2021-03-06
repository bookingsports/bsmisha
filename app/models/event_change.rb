# == Schema Information
#
# Table name: event_changes
#
#  id         :integer          not null, primary key
#  event_id   :integer
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

  belongs_to :event, required: true

  scope :past, -> { where arel_table['new_stop'].lt Time.now }
  scope :future, -> { where arel_table['new_start'].gt Time.now }
  scope :event_past, -> { where arel_table['old_stop'].lt Time.now }
  scope :event_future, -> { where arel_table['old_start'].gt Time.now }
  scope :of_areas, ->(*areas) do
    joins(event: :events_areas).
    where(events_areas: {area_id: areas}).uniq
  end

  enum status: [:unpaid, :paid, :paid_approved, :canceled]

  after_save :update_event

  def paid?
    status == "paid"
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

  def pay!
    rec = event.user.recoupments.where(area: event.area).first
    discount = event.user.discounts.where(area: event.area).first
    percent = 0

    if rec.present? && rec.price > total
      rec.update price: (rec.price - total)
    elsif rec.present? && rec.price <= total && rec.price > 0
      percent = total - rec.price
      rec.destroy
    else
      percent = 1
    end

    if discount
      percent *= discount.percent
    end

    pay_with_percent! percent
    self.update status: :paid
  end

  def convert_for_order
    hash = {pname: ["Комиссия BookingSports",self.name],
            pcode: [],
            price: [],
            order_qty: [1,1],
            order_vat: [0,0],
            order_mplace_merchant: [Rails.application.secrets.merchant_st, self.event.area.stadium.account.merchant_id] }
    #данные по комисси сервиса BS
    hash[:pcode].push(self.id.to_s + "_com")
    hash[:price].push(self.calculate_new_price*Rails.application.secrets.tax.to_f/100)
    #данные по стадиону
    hash[:pcode].push("ec_" + self.event_id.to_s + "_" + self.id.to_s)
    hash[:price].push((self.calculate_new_price)*(1.0 - Rails.application.secrets.tax.to_f/100))
    puts hash
    return hash
  end

  private
    def pay_with_percent! percent
      if percent > 0
        event.user.wallet.withdraw! total * percent
        event.area.stadium.user.wallet.deposit_with_tax_deduction! total * percent
      end
    end
end
