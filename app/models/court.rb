class Court < Product
  belongs_to :stadium, foreign_key: :parent_id
  has_many :coaches_courts
  has_many :coaches, through: :coaches_courts

  delegate :owner, to: :stadium

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
