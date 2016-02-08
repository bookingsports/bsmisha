# == Schema Information
#
# Table name: categories
#
#  id         :integer          not null, primary key
#  name       :string
#  ancestry   :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  slug       :string
#  icon       :string
#

class Category < ActiveRecord::Base
  has_paper_trail
  
  include FriendlyId

  has_many :stadiums

  default_scope -> { order(created_at: :desc) }

  friendly_id :name, use: [:slugged]
  mount_uploader :icon, MapIconUploader
  has_ancestry
end
