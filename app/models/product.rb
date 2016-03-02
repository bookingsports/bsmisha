# == Schema Information
#
# Table name: products
#
#  id           :integer          not null, primary key
#  category_id  :integer
#  user_id      :integer
#  name         :string
#  phone        :string
#  description  :text
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  address      :string
#  latitude     :float            default(55.75)
#  longitude    :float            default(37.61)
#  slug         :string
#  status       :integer          default(0)
#  type         :string
#  parent_id    :integer
#  email        :string
#  avatar       :string
#  price        :float
#  change_price :float
#  opens_at     :time
#  closes_at    :time
#

class Product < ActiveRecord::Base
  has_paper_trail

  include FriendlyId
  include ProductConcern
  include PapertrailStiFixConcern

  belongs_to :category
  belongs_to :user

  has_many :pictures, as: :imageable
  has_many :reviews, as: :reviewable
  has_many :special_prices
  has_many :events
  has_many :orders, through: :events

  accepts_nested_attributes_for :pictures, allow_destroy: true

  default_scope -> { order(created_at: :desc) }

  friendly_id :name, use: [:slugged]
  mount_uploader :avatar, PictureUploader

  enum status: [:pending, :active, :locked]

  def customers
    User.find(events.joins(:order).pluck("orders.user_id").uniq)
  end

  def price options=nil
    (options && special_prices.current.price(options)) || attributes['price'] || 0
  end

  def price_for_event event
    price * event.duration_in_hours
  end
end
