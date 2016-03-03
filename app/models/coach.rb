# == Schema Information
#
# Table name: coaches
#
#  id          :integer          not null, primary key
#  user_id     :integer
#  slug        :string
#  description :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

class Coach < ActiveRecord::Base
  has_paper_trail
  include CoachConcern
  include FriendlyId

  belongs_to :user
  has_many :coaches_areas
  has_many :areas, through: :coaches_areas
  validate :has_at_least_one_area, on: :stadium_dashboard
  validates :user, presence: true

  has_one :account, as: :accountable
  after_create :create_account

  delegate :name, to: :user
  friendly_id :name, use: [:slugged]

  accepts_nested_attributes_for :user, :account

  delegate :email, to: :user

  def has_areas?
    areas.size > 0
  end

  def has_at_least_one_area
    if areas.size < 1
      errors.add :areas, "Выберите хотя бы одну площадку."
    end
  end
end
