class CoachUser < User
  has_one :coach, foreign_key: "user_id", dependent: :destroy
  has_one :product, foreign_key: "user_id", dependent: :destroy
  accepts_nested_attributes_for :coach

  delegate :description, to: :coach

  after_initialize :make_coach, unless: "coach.present?"

  def make_coach
    self.build_coach
  end

  def name
    attributes["name"] || "Тренер ##{id}"
  end

  def products
    coach.courts
  end
end
