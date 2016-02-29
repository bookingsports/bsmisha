# == Schema Information
#
# Table name: coaches_areas
#
#  id       :integer          not null, primary key
#  coach_id :integer
#  area_id :integer
#  price    :decimal(8, 2)    default(0.0)
#

class CoachesArea < ActiveRecord::Base
  include CoachesAreaConcern
  has_paper_trail

  belongs_to :coach
  belongs_to :area
end
