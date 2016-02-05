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
  belongs_to :coach
  belongs_to :court

  delegate :name, :stadium, :events, to: :court
end
