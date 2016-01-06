class Coach < Product
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
