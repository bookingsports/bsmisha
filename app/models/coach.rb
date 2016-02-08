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

class Coach < Product
  include CoachConcern
  
  has_many :coaches_courts
  has_many :courts, through: :coaches_courts
  validate :has_at_least_one_court, on: :stadium_dashboard

  delegate :email, to: :owner

  def has_courts?
    courts.size > 0
  end

  def name_with_stadium
    name
  end

  def has_at_least_one_court
    if courts.size < 1
      errors.add :courts, "Выберите хотя бы один корт."
    end
  end

  def name
    attributes["name"] || "Без имени"
  end
end
