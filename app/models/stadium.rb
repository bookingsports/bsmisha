# == Schema Information
#
# Table name: stadiums
#
#  id          :integer          not null, primary key
#  user_id     :integer
#  category_id :integer
#  name        :string           default("Без названия"), not null
#  phone       :string
#  description :string
#  address     :string
#  latitude    :float
#  longitude   :float
#  slug        :string
#  status      :integer          default(0)
#  email       :string
#  main_image  :string
#  opens_at    :time
#  closes_at   :time
#  created_at  :datetime
#  updated_at  :datetime
#

class Stadium < ActiveRecord::Base
  include StadiumConcern
  include FriendlyId

  belongs_to :user
  belongs_to :category, inverse_of: :stadiums
  has_many :areas, dependent: :destroy
  has_many :pictures, as: :imageable
  has_many :reviews, as: :reviewable

  has_one :account, as: :accountable
  has_many :stadium_services, dependent: :destroy
  has_many :services, through: :stadium_services

  accepts_nested_attributes_for :areas, reject_if: :all_blank, allow_destroy: true
  accepts_nested_attributes_for :stadium_services, reject_if: :all_blank, allow_destroy: true
  accepts_nested_attributes_for :user, :account

  after_create :make_area
  after_create :create_account
  after_create :parse_address
  after_save :update_counter_cache
  after_destroy :update_counter_cache

  accepts_nested_attributes_for :pictures, allow_destroy: true

  default_scope -> { order(created_at: :desc) }

  friendly_id :name, use: [:slugged]
  mount_uploader :main_image, PictureUploader

  enum status: [:pending, :active, :locked]

  validates_associated :stadium_services, :areas
  validates :opens_at, :closes_at, :address, :category, presence: true
  #validates :closes_at, greater_by_30_min: {than: :opens_at}, allow_blank: true

  def events
    Event.where area_id: area_ids
  end

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

  def update_counter_cache
    if self.category.present?
      self.category.active_stadiums_counter = self.category.stadiums.active.count
      self.category.save
    end
  end

  private

    def parse_address
      AddressParser.new(self).perform
    end

end
