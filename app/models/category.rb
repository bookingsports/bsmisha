class Category < ActiveRecord::Base
  include FriendlyId

  has_many :stadiums

  default_scope -> { order(created_at: :desc) }

  friendly_id :name, use: [:slugged]
  mount_uploader :icon, MapIconUploader
  has_ancestry
end
