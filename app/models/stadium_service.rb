# == Schema Information
#
# Table name: stadium_services
#
#  id         :integer          not null, primary key
#  stadium_id :integer
#  service_id :integer
#  price      :float
#  periodic   :boolean          default(FALSE)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class StadiumService < ActiveRecord::Base
  include StadiumServiceConcern
  has_paper_trail

  belongs_to :stadium, required: true
  belongs_to :service, required: true
  has_and_belongs_to_many :events
  accepts_nested_attributes_for :service

  validates :price, presence: true, numericality: { greater_than_or_equal_to: 0 }

  delegate :user, to: :stadium

  def name
    "Услуга #{service_id.present? ? service.name : ""} стадиона #{stadium_id.present? ? stadium.name : ""}"
  end

  def price_formatted
    periodicity = periodic? ? ' в час' : ''
    "#{price} руб.#{periodicity}"
  end

  def service_name_and_price
    "#{service.name} (#{price_formatted})"
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
