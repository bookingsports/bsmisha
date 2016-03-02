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
#  status                 :integer          default(0)
#  phone                  :string
#  created_at             :datetime
#  updated_at             :datetime
#

class StadiumUser < User
  include StadiumUserConcern

  has_one :stadium, foreign_key: "user_id", dependent: :destroy

  delegate :areas, to: :stadium

  enum status: [:pending, :active]

  after_create :create_stadium

  def name
    attributes["name"] || attributes["email"]
  end

  def special_prices
    (stadium.special_prices.to_a + stadium.areas.map { |area| area.special_prices.to_a }.flatten).uniq
  end

  def products
    stadium.areas
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
