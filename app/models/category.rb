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
#  position   :integer
#

class Category < ActiveRecord::Base
  include CategoryConcern
  include FriendlyId

  has_paper_trail

  has_many :stadiums

  friendly_id :name, use: [:slugged]
  mount_uploader :icon, MapIconUploader
  mount_uploader :main_image, CategoryPictureUploader
  has_ancestry

  default_scope ->{ order(:position) }

  def parent_enum
    Category.where.not(id: id).map { |c| [ c.name, c.id ] }
  end
end
