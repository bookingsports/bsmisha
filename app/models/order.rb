# == Schema Information
#
# Table name: orders
#
#  id         :integer          not null, primary key
#  user_id    :integer
#  total      :decimal(8, 2)
#  status     :integer          default(0)
#  comment    :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Order < ActiveRecord::Base
  include OrderConcern

  has_paper_trail

  belongs_to :user
  has_many :events, dependent: :destroy
  has_many :event_changes, dependent: :destroy
  has_many :areas, through: :events
  accepts_nested_attributes_for :events

  after_save do
    if unpaid?
      update_columns("total" =>  calculate_total)
    end
  end

  enum status: [:unpaid, :paid, :change, :rain, :other]

  def name
    "Заказ №#{id} на сумму #{total} #{user_id.present? ? "пользователя " + user.try(:name).to_s : ""}"
  end

  def area_ids
    (events.map(&:area_id) + event_changes.map{|e| e.event.area_id}).uniq
  end

  def calculate_total
    _total = events.map(&:price).inject(:+).to_i + event_changes.map(&:total).inject(:+).to_i - Recoupment.where(area: area_ids).uniq.map(&:price).sum
    _total < 0 ? 0 : _total
  end

  def total_hours
    events.map(&:duration_in_hours).inject(:+)
  end

  def guid
    "#%06d" % id
  end

  def human_status
    if status?
      I18n.translate status, scope: "simple_form.options.order.status"
    else
      ""
    end
  end

  def associated_emails
    events.map{|e| e.area.stadium.user.email}.flatten.uniq.to_a
  end

  def pay!
    unless self.paid?
      transaction = ActiveRecord::Base.transaction do
        self.events.each do |event|
          if event.overlaps? event.start, event.stop
            order.errors.add(:event, 'накладываются на другие события')
            raise ActiveRecord::Rollback
          end
          rec = user.recoupments.where(area: event.area).first
          if rec.present? && rec.price > event.price
            rec.update price: (rec.price - event.price)
          elsif rec.present? && rec.price <= event.price && rec.price > 0
            user.wallet.withdraw! event.price - rec.price
            rec.destroy
          else
            user.wallet.withdraw! event.price
            event.area.stadium.user.wallet.deposit_with_tax_deduction! event.area_price
            if event.coach.present?
             event.coach.user.wallet.deposit_with_tax_deduction!(event.coach_percent_price)
             event.area.stadium.user.wallet.deposit_with_tax_deduction!(event.coach_stadium_price)
           end
            event.stadium_services.present? && event.area.stadium.user.wallet.deposit_with_tax_deduction!(event.stadium_services_price)
          end
        end
        self.event_changes.each do |event_change|
          rec = user.recoupments.where(area: event_change.event.area).first
          if rec.present? && rec.price > event_change.total
            rec.update price: (rec.price - event_change.total)
          elsif rec.present? && rec.price <= event_change.total && rec.price > 0
            user.wallet.withdraw! event_change.total - rec.price
            rec.destroy
          else
            user.wallet.withdraw! event_change.total
            event_change.event.area.stadium.user.wallet.deposit_with_tax_deduction! event_change.total
          end
        end
      end

      if transaction
        self.paid!
      end
    end
  end
end
