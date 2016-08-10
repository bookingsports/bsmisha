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

  belongs_to :stadium, required: true
  has_and_belongs_to_many :events

  validates :name, presence: true
  validates :price, presence: true, numericality: { greater_than_or_equal_to: 0 }

  delegate :user, to: :stadium

  def display_name
    "Услуга #{attributes["name"]} стадиона #{stadium_id.present? ? stadium.name : ""}"
  end

  def price_formatted
    periodicity = periodic? ? ' в час' : ''
    "#{price} руб.#{periodicity}"
  end

  def service_name_and_price
    "#{name} (#{price_formatted})"
  end

  def price_for_event event
    periodic? ? price * event.duration_in_hours : price
  end
end
