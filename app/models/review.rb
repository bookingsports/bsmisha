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

  belongs_to :reviewable, polymorphic: true
  belongs_to :user

  default_scope -> { order(created_at: :desc) }

  validates :rating, inclusion: { in: 0..5 }
end
