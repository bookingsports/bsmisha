class OrderDiscount < ActiveRecord::Base
  include OrderDiscountConcern
  has_paper_trail

  belongs_to :area, required: true
  validates :start, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :value, numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 100 }
  validates :area_id, uniqueness: { scope: :start }

  def percent
    (100 - value) / 100
  end

  def name
    "Скидка на заказ \##{id}"
  end
end
