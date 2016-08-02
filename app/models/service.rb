# == Schema Information
#
# Table name: services
#
#  id         :integer          not null, primary key
#  name       :string
#  icon       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Service < ActiveRecord::Base
  include ServiceConcern
  has_paper_trail

  has_many :stadium_services, dependent: :destroy
  has_many :stadiums, through: :stadium_services

  validates :name, presence: true
end
