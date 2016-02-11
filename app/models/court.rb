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

class Court < Product
  include CourtConcern

  belongs_to :stadium, foreign_key: :parent_id
  has_many :coaches_courts
  has_many :coaches, through: :coaches_courts

  # delegate :owner, to: :stadium

  def display_name
    "#{parent_id.present? ? stadium.name + " - " : "" }#{name}"
  end

  def change_price
    attributes["change_price"] || 0
  end

  def special_prices
    if super.any?
      super
    else
      stadium.special_prices
    end
  end

  def name_with_stadium
    stadium.name.to_s + " — корт " + name.to_s
  end

  def product_services
    if super.any?
      super
    else
      stadium.product_services
    end
  end

  def kendo_court_id
    stadium.courts.to_a.index(self) % 10
  end
end
