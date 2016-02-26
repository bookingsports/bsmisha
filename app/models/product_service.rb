# == Schema Information
#
# Table name: product_services
#
#  id         :integer          not null, primary key
#  product_id :integer
#  service_id :integer
#  price      :decimal(8, 2)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  type       :string
#

class ProductService < ActiveRecord::Base
  include ProductServiceConcern
  has_paper_trail

  belongs_to :product
  belongs_to :service
  has_and_belongs_to_many :events
  accepts_nested_attributes_for :service

  delegate :user, to: :product

  def name
    "Услуга #{service_id.present? ? service.name : ""} продукта #{product_id.present? ? product.name : ""}"
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
