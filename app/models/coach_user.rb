# == Schema Information
#
# Table name: users
#
#  id                     :integer          not null, primary key
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  reset_password_token   :string
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer          default(0), not null
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :inet
#  last_sign_in_ip        :inet
#  created_at             :datetime
#  updated_at             :datetime
#  name                   :string
#  role                   :integer
#  type                   :string
#  slug                   :string
#  avatar                 :string
#  status                 :integer
#  phone                  :string
#

class CoachUser < User
  include CoachUserConcern

  has_one :coach, foreign_key: 'user_id', dependent: :destroy
  has_one :product, foreign_key: "user_id", dependent: :destroy

  has_one :account, as: :accountable
  after_create :create_account

  accepts_nested_attributes_for :coach, :account

  after_initialize :build_coach, unless: 'coach.present?'

  delegate :description, to: :coach

  def name
    attributes["name"] || "Тренер ##{id}"
  end

  def products
    coach.courts
  end
end
