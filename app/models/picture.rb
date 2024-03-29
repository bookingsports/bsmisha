# == Schema Information
#
# Table name: pictures
#
#  id             :integer          not null, primary key
#  name           :string
#  imageable_id   :integer
#  imageable_type :string
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  description    :string
#

class Picture < ActiveRecord::Base
  include PictureConcern

  has_paper_trail

  belongs_to :imageable, polymorphic: true

  mount_uploader :name, PictureUploader

  def description
    attributes["description"] || "Изображение без описания"
  end
end
