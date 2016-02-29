# == Schema Information
#
# Table name: stadiums
#
#  id          :integer          not null, primary key
#  user_id     :integer
#  name        :string
#  phone       :string
#  description :string
#  address     :string
#  latitude    :float
#  longitude   :float
#  slug        :string
#  status      :integer
#  email       :string
#  avatar      :string
#  opens_at    :time
#  closes_at   :time
#

class Stadium < ActiveRecord::Base
  include StadiumConcern
  include FriendlyId

  belongs_to :user
  belongs_to :category, inverse_of: :stadiums
  has_many :areas, dependent: :destroy, inverse_of: :stadium, foreign_key: :parent_id
  has_many :events, through: :areas
  has_many :pictures, as: :imageable
  has_many :reviews, as: :reviewable

  accepts_nested_attributes_for :areas, reject_if: :all_blank, allow_destroy: true
  accepts_nested_attributes_for :user

  has_many :stadium_services, dependent: :destroy
  has_many :services, through: :stadium_services

  after_create :make_area
  after_save :parse_address

  accepts_nested_attributes_for :pictures, allow_destroy: true

  default_scope -> { order(created_at: :desc) }

  friendly_id :name, use: [:slugged]
  mount_uploader :avatar, PictureUploader

  enum status: [:pending, :active, :locked]

  def make_area
    areas.create! name: 'Основная'
  end

  def coaches
    areas.map(&:coaches).flatten.uniq
  end

  def as_json(params = {})
    {
      icon: ActionController::Base.helpers.asset_path(category.try(:icon)),
      position: {
        lat: latitude.to_f,
        lng: longitude.to_f
      },
      name: name
    }
  end

  def name
    attributes['name'] || 'Без названия'
  end

  private

    def parse_address
      AddressParser.new(self).perform
    end
end
