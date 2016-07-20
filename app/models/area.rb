# == Schema Information
#
# Table name: areas
#
#  id           :integer          not null, primary key
#  stadium_id   :integer
#  name         :string
#  description  :string
#  slug         :string
#  change_price :decimal(, )      default(0.0)
#  created_at   :datetime
#  updated_at   :datetime
#

class Area < ActiveRecord::Base
  include AreaConcern
  include FriendlyId

  belongs_to :stadium, counter_cache: true
  has_many :coaches_areas, dependent: :destroy
  has_many :coaches, through: :coaches_areas
  has_many :events, dependent: :restrict_with_error
  has_many :prices, dependent: :destroy
  has_many :daily_price_rules, through: :prices
  has_many :recoupments, dependent: :destroy

  validates :name, :stadium_id, presence: true
  validates :change_price, numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 100 }

  accepts_nested_attributes_for :recoupments, reject_if: :all_blank, allow_destroy: true

  friendly_id :name, use: [:slugged]

  def display_name
    "#{stadium_id.present? ? stadium.name + " - " : "" }#{name}"
  end

  def name_with_stadium
    stadium.name.to_s + " - площадка " + name.to_s
  end

  def kendo_area_id
    id % 30
  end
end
