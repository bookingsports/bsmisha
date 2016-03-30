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

  belongs_to :coach, required: true
  belongs_to :area, required: true

  def name_and_price
    "#{coach.name} (#{price} руб. в час)"
  end
end
