class Dashboard::PicturesController < DashboardController
  before_filter :find_picture, except: [ :index, :create ]
  before_filter :find_imageable
  respond_to :html, :js

  def index
    @pictures = @imageable.pictures
  end

  def create
    @picture = @imageable.pictures.new name: params[:file]
    @imageable.save!
  end

  def update
    @picture.update picture_params

    respond_with @picture
  end

  def destroy
    @picture.delete
  end

  private

    def find_imageable
      @imageable = current_user.product
    end

    def find_picture
      @picture = Picture.find(params[:id]) if params[:id]
    end

    def picture_params
      params.require(:picture).permit(:name, :description)
    end
end
