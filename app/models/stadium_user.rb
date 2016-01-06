class StadiumUser < User
  has_one :stadium, foreign_key: "user_id", dependent: :destroy
  has_one :product, foreign_key: "user_id", dependent: :destroy

  delegate :courts, to: :stadium

  enum status: [:pending, :active]
  after_initialize :set_status, if: :new_record?
  after_initialize :make_stadium, unless: "stadium.present?"

  def set_status
    self.status = "pending" unless self.status
  end

  def make_stadium
    self.create_stadium
  end

  def name
    attributes["name"] || attributes["email"]
  end

  def special_prices
    (stadium.special_prices.to_a + stadium.courts.map { |court| court.special_prices.to_a }.flatten).uniq
  end

  def products
    stadium.courts
  end

  def events
    Event.where(id: event_ids)
  end

  def event_ids
    products.flat_map {|product| product.events}.map(&:id)
  end

  def new_event options={}
    Event.new options.merge(user_id: self.id)
  end
end
