class Discount < ActiveRecord::Base
  include DiscountConcern
  has_paper_trail

  belongs_to :user, required: true
  belongs_to :area, required: true

  validates :user, :value, :area, presence: true
  validates :area_id, uniqueness: { scope: :user_id }
  validates :value, numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 100 }

  def percent
    (100 - value) / 100
  end
end
