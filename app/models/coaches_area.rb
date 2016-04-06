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

  def name_and_price
    "#{coach.name} (#{price} руб. в час)"
  end

  def area_and_price
    "#{area.name} - #{price} руб. в час"
  end
end
