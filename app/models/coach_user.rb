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
#  name                   :string
#  type                   :string           default("Customer")
#  avatar                 :string
#  phone                  :string
#  created_at             :datetime
#  updated_at             :datetime
#

class CoachUser < User
  include CoachUserConcern

  has_one :coach, foreign_key: 'user_id', dependent: :destroy
  after_create :create_coach

  accepts_nested_attributes_for :coach

  def areas
    coach.coaches_areas.where(status: CoachesArea.statuses[:active]).map(&:area).uniq
  end

  def product_areas
    coach.coaches_areas.active.map(&:area).uniq
  end

  def name
    attributes["name"] || "Тренер ##{id}"
  end
end
