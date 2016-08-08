# == Schema Information
#
# Table name: static_pages
#
#  id         :integer          not null, primary key
#  text       :text
#  title      :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  slug       :string
#

class StaticPage < ActiveRecord::Base
  include StaticPageConcern
  has_paper_trail

  include FriendlyId
  friendly_id :title, use: [:slugged]

  validates_uniqueness_of :slug

  def name
    title
  end

  def should_generate_new_friendly_id?
    slug.blank? || title_changed?
  end
end
