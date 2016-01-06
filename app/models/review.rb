class Review < ActiveRecord::Base
  belongs_to :reviewable, polymorphic: true
  belongs_to :user

  default_scope -> { order(created_at: :desc) }

  validates :rating, inclusion: { in: 0..5 }
end
