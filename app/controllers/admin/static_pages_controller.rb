class Admin::StaticPagesController < AdminController
  respond_to :html

  def index
    @pages = StaticPage.all
  end

  def new
    @page = StaticPage.new
  end

  def edit
    @page = StaticPage.friendly.find params[:id]
  end

  def update
    @page = StaticPage.friendly.find params[:id]

    @page.update static_page_params

    respond_with @page, location: admin_static_pages_path
  end

  def create
    @page = StaticPage.create static_page_params

    respond_with @page, location: admin_static_pages_path
  end

  def destroy
    @page = StaticPage.friendly.find params[:id]

    @page.destroy

    respond_with @page, location: admin_static_pages_path
  end

  private

    def static_page_params
      params.require(:static_page).permit(:title, :text)
    end
end
