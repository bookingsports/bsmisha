# == Schema Information
#
# Table name: areas
#
#  id           :integer          not null, primary key
#  stadium_id   :integer
#  name         :string
#  description  :string
#  slug         :string
#  price        :decimal(, )      default(0.0)
#  change_price :decimal(, )      default(0.0)
#  opens_at     :time
#  closes_at    :time
#  created_at   :datetime
#  updated_at   :datetime
#

class Area < ActiveRecord::Base
  include AreaConcern

  belongs_to :stadium
  has_many :coaches_areas
  has_many :coaches, through: :coaches_areas
  has_many :events
  has_many :prices

  validates :name, :stadium_id, presence: true
  validates :change_price, numericality: { greater_than_or_equal_to: 0 }

  def display_name
    "#{stadium_id.present? ? stadium.name + " - " : "" }#{name}"
  end

  def name_with_stadium
    stadium.name.to_s + " - площадка " + name.to_s
  end

  def kendo_area_id
    stadium.areas.to_a.index(self) % 10
  end

  def price_for_event event
    price * event.duration_in_hours
  end
end
