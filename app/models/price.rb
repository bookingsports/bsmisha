# == Schema Information
#
# Table name: prices
#
#  id         :integer          not null, primary key
#  start      :datetime
#  stop       :datetime
#  is_sale    :boolean
#  area_id    :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Price < ActiveRecord::Base
  include PriceConcern

  has_paper_trail

  belongs_to :area
  has_many :daily_price_rules, dependent: :destroy

  validates :area_id, :start, :stop, presence: true
  validates :stop, greater_by_30_min: {than: :start}, allow_blank: true
  validates :start, :stop, step_by_30_min: true, allow_blank: true

  after_create { daily_price_rules.create }

  accepts_nested_attributes_for :daily_price_rules

  # return value for current time
  scope :current, -> do
    where('LOCALTIMESTAMP BETWEEN "start" AND "stop"').last || new
  end

  def name
    "Период с #{start} по #{stop}"
  end
end
