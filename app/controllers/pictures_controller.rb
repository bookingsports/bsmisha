class PicturesController < NestedResourcesController
  before_filter :find_picture, except: :index

  private

    def find_picture
      @picture = Picture.find(params[:id]) if params[:id]
    end
end
