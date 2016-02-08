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

class PicturesController < NestedResourcesController
  before_filter :find_picture, except: :index

  private

    def find_picture
      @picture = Picture.find(params[:id]) if params[:id]
    end
end
