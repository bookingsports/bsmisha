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

  belongs_to :user, class_name: "User"
  has_many :coaches_areas, dependent: :destroy
  has_many :areas, through: :coaches_areas
  has_many :events

  has_one :account, as: :accountable, dependent: :destroy

  friendly_id :name, use: [:slugged]

  accepts_nested_attributes_for :user, :account
  accepts_nested_attributes_for :coaches_areas, reject_if: :all_blank, allow_destroy: true

  delegate :email, to: :user
  delegate :avatar, to: :user
  delegate :phone, to: :user

  after_create :create_account

  validates_uniqueness_of :slug

  def customers
    Customer.joins(:events).where(events: {coach_id: id}).uniq
  end

  def has_areas?
    areas.size > 0
  end

  def name
    user.present? ? user.name : nil
  end

  def should_generate_new_friendly_id?
    slug.blank? || user.name_changed?
  end
end
