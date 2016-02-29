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

class Stadium < Product
  include StadiumConcern

  belongs_to :category, inverse_of: :stadiums
  has_many :areas, dependent: :destroy, inverse_of: :stadium, foreign_key: :parent_id

  accepts_nested_attributes_for :areas, reject_if: :all_blank, allow_destroy: true
  accepts_nested_attributes_for :user

  after_create :make_area
  after_save :parse_address

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
