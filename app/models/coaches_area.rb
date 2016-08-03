# == Schema Information
#
# Table name: coaches_areas
#
#  id       :integer          not null, primary key
#  coach_id :integer
#  area_id  :integer
#  price    :decimal(8, 2)    default(0.0)
#

class CoachesArea < ActiveRecord::Base
  include CoachesAreaConcern
  has_paper_trail

  belongs_to :coach
  belongs_to :area, required: true

  validates :price, presence: true, numericality: { greater_than_or_equal_to: 0}
  validates :stadium_percent, presence: true, numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 100}

  enum status: [:pending, :active, :locked]

  def price_formatted
    "#{price} руб. в час"
  end

  def name_and_price
    "#{coach.name} (#{price_formatted})"
  end

  def area_and_price
    "#{area.name} - #{price_formatted}"
  end

  def name
    "Привязка тренера #{coach.name} к площадке #{area.name}"
  end
end
