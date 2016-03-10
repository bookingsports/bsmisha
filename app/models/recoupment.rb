class Recoupment < ActiveRecord::Base
  belongs_to :user
  belongs_to :area

  validates :user, :duration, :area, presence: true
end
