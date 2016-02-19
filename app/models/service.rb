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

  has_many :product_services, dependent: :destroy
end
