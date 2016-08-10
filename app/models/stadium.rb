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
  has_paper_trail

  belongs_to :user
  belongs_to :category, inverse_of: :stadiums
  has_many :areas, dependent: :destroy
  has_many :prices, -> { where('prices.stop > ?', Time.now) },  through: :areas
  has_many :daily_price_rules, through: :prices
  has_many :pictures, as: :imageable
  has_many :reviews, as: :reviewable, dependent: :destroy

  has_one :account, as: :accountable, dependent: :destroy
  has_many :services, dependent: :destroy

  accepts_nested_attributes_for :areas, reject_if: :all_blank, allow_destroy: true
  accepts_nested_attributes_for :services, reject_if: :all_blank, allow_destroy: true
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

  validates_uniqueness_of :slug
  validates_associated :services, :areas
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
      self.category.active_stadiums_counter = self.category.stadiums.active.select(&:has_areas?).count
      self.category.save
    end
  end

  def has_areas?
    areas_count > 0
  end

  private

    def parse_address
      AddressParser.new(self).perform
    end

    def should_generate_new_friendly_id?
      slug.blank? || name_changed?
    end

end
