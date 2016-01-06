class Product < ActiveRecord::Base
  include FriendlyId

  belongs_to :category
  belongs_to :owner, class_name: "User", foreign_key: :user_id
  has_many :pictures, as: :imageable
  has_many :reviews, as: :reviewable
  has_many :special_prices
  has_and_belongs_to_many :events
  has_many :orders, through: :events
  has_many :product_services, dependent: :destroy
  has_many :services, through: :product_services

  accepts_nested_attributes_for :product_services

  default_scope -> { order(created_at: :desc) }

  friendly_id :name, use: [:slugged]
  mount_uploader :avatar, PictureUploader
  enum status: [:pending, :active, :locked]

  def customers
    User.find(events.joins(:order).pluck("orders.user_id").uniq)
  end

  def price options=nil
    (options && special_prices.current.price(options)) || attributes["price"] || 0
  end

  def price_for_event event
    event.hours.map{ |hour| price(hour: hour, event: event) }.reduce(:+) || 0
  end
end
