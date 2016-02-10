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
#  price        :decimal(8, 2)
#  change_price :decimal(8, 2)
#  opens_at     :datetime
#  closes_at    :datetime
#

class Stadium < Product
  include StadiumConcern

  belongs_to :user, class_name: "StadiumUser", foreign_key: "user_id"
  has_many :courts, dependent: :destroy, foreign_key: :parent_id
  accepts_nested_attributes_for :courts, :reject_if => :all_blank, :allow_destroy => true

  after_create :make_court
  after_save :parse_address

  def make_court
    courts.create! name: "Основной"
  end

  def coaches
    courts.map(&:coaches).flatten.uniq
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
    attributes["name"] || 'Без названия'
  end

  private

    def parse_address
      AddressParser.new(self).perform
    end
end
