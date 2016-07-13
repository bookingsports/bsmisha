# == Schema Information
#
# Table name: reviews
#
#  id              :integer          not null, primary key
#  reviewable_id   :integer
#  reviewable_type :string
#  text            :text
#  user_id         :integer
#  verified        :boolean
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  rating          :integer
#

class Review < ActiveRecord::Base
  include ReviewConcern
  has_paper_trail

  after_save :update_counter_cache
  after_destroy :update_counter_cache

  belongs_to :reviewable, polymorphic: true
  belongs_to :user

  default_scope -> { order(created_at: :desc) }

  validates :rating, inclusion: { in: 1..5 }, presence: true
  validates :text, presence: true

  def name
    "Обзор #{user_id.present? ? "пользователя " + user.name : ""} #{reviewable_id.present? ? "на продукт " + reviewable.name.to_s : ""}"
  end

  def update_counter_cache
    self.reviewable.verified_reviews_counter = self.reviewable.reviews.where(verified: true).count
    self.reviewable.save
  end
end
