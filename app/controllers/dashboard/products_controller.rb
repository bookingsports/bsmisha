class Dashboard::ProductsController < DashboardController
  before_filter :find_product

  def edit
  end

  def update
    @product.update product_params

    render :edit
  end

  private

    def find_product
      @product = current_user.product
    end

    def product_params
      params.require(:product).permit(:name, :password, :password_confirmation, :email, :price, :phone, :avatar, :name, :address, :telephone, :description, :category_id, :phone, :latitude, :longitude, court_ids: [], profile_attributes: [:description], courts_attributes: [:id, :name, :price, :change_price, :category_id, :_destroy], product_services_attributes: [:id, :periodic, :price, :_destroy, service_attributes: [:id, :name]])
    end
end
