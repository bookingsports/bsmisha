# == Schema Information
#
# Table name: coaches_courts
#
#  id       :integer          not null, primary key
#  coach_id :integer
#  court_id :integer
#  price    :decimal(8, 2)    default(0.0)
#

class CoachesCourt < ActiveRecord::Base
  include CoachesCourtConcern
  has_paper_trail

  belongs_to :coach
  belongs_to :court
end
