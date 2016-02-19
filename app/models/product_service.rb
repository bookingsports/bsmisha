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

  self.inheritance_column = "class"

  belongs_to :product
  belongs_to :service
  has_and_belongs_to_many :events
  accepts_nested_attributes_for :service

  delegate :owner, to: :product

  def service_name_and_price
    periodicity = self.periodic? ? " в час" : ""
    "#{service.name} (#{price} руб.#{periodicity})"
  end

  def periodic?
    self.type == "Periodic"
  end

  def periodic= bool
    self.type = "Periodic" if bool || bool == "1"
  end

  def service_attributes= attributes
    if service = Service.find_by_name(attributes["name"]).presence
      self.service_id = service.id
    else
      super
    end
  end

  def price_for_event event
    if periodic?
      price.to_i * event.duration_in_hours.to_i
    else
      price.to_i
    end
  end
end
