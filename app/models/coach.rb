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

class Coach < Product
  include CoachConcern

  has_many :coaches_areas
  has_many :areas, through: :coaches_areas
  validate :has_at_least_one_area, on: :stadium_dashboard

  has_one :account, as: :accountable
  after_create :create_account

  accepts_nested_attributes_for :user

  delegate :email, to: :user

  def has_areas?
    areas.size > 0
  end

  def name_with_stadium
    name
  end

  def has_at_least_one_area
    if areas.size < 1
      errors.add :areas, "Выберите хотя бы одну площадку."
    end
  end

  def name
    attributes["name"] || "Без имени"
  end
end
