# == Schema Information
#
# Table name: recoupments
#
#  id         :integer          not null, primary key
#  duration   :integer
#  user_id    :integer
#  area_id    :integer
#  reason     :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Recoupment < ActiveRecord::Base
  include RecoupmentConcern

  belongs_to :user
  belongs_to :area

  validates :user, :duration, :area, presence: true
end
