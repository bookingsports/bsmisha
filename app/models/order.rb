# == Schema Information
#
# Table name: orders
#
#  id         :integer          not null, primary key
#  user_id    :integer
#  total      :decimal(8, 2)
#  status     :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  comment    :string
#

class Order < ActiveRecord::Base
  include OrderConcern

  has_paper_trail

  belongs_to :user
  has_many :events, dependent: :destroy
  has_many :event_changes, dependent: :destroy
  accepts_nested_attributes_for :events

  enum status: [:unpaid, :paid, :change, :rain, :other]

  def name
    "Заказ №#{id} на сумму #{total} #{user_id.present? ? "пользователя " + user.name : ""}"
  end

  def total
    events.map(&:total).inject(:+).to_i + event_changes.map(&:total).inject(:+).to_i
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
    events.map(&:products).flatten.uniq.map(&:email).to_a
  end

  def pay!
    unless self.paid?
      transaction = ActiveRecord::Base.transaction do
        user.wallet.withdraw! self.total
        self.events.each do |event|
          event.associated_payables_with_price.each do |item|
            item[:product].owner.wallet.deposit_with_tax_deduction! item[:total]
          end
        end
      end

      if transaction
        self.paid!
      end
    end
  end
end
