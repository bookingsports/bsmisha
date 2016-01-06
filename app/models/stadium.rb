class Stadium < Product
  has_many :courts, dependent: :destroy, foreign_key: :parent_id
  accepts_nested_attributes_for :courts, :reject_if => :all_blank, :allow_destroy => true

  after_create :make_court

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
end
