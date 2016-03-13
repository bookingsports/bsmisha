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

class StadiumUser < User
  include StadiumUserConcern

  has_one :stadium, foreign_key: "user_id", dependent: :destroy
  accepts_nested_attributes_for :stadium

  has_many :areas, through: :stadium

  enum status: [:pending, :active]

  after_create :create_stadium

  def stadium_events
    Event.where area_id: area_ids
  end

  def prices
    (stadium.prices.to_a + stadium.areas.map { |area| area.prices.to_a }.flatten).uniq
  end
end
