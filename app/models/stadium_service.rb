# == Schema Information
#
# Table name: stadium_services
#
#  id         :integer          not null, primary key
#  product_id :integer
#  service_id :integer
#  price      :float
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  periodic   :boolean          default(FALSE)
#

class StadiumService < ActiveRecord::Base
  include StadiumServiceConcern
  has_paper_trail

  belongs_to :stadium
  belongs_to :service
  has_and_belongs_to_many :events
  accepts_nested_attributes_for :service

  delegate :user, to: :stadium

  def name
    "Услуга #{service_id.present? ? service.name : ""} стадиона #{stadium_id.present? ? stadium.name : ""}"
  end

  def service_name_and_price
    periodicity = periodic? ? ' в час' : ''
    "#{service.name} (#{price} руб.#{periodicity})"
  end

  def service_attributes= attributes
    if service = Service.find_by_name(attributes["name"]).presence
      self.service_id = service.id
    else
      super
    end
  end

  def price_for_event event
    periodic? ? price * event.duration_in_hours : price
  end
end
