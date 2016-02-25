class Dashboard::ProductsController < DashboardController
  before_filter :find_product

  def edit
    gon.latLng = {lat: @product.latitude || 55.75, lng: @product.longitude || 37.61}
  end

  def update
    @product.update product_params
    redirect_to edit_dashboard_product_path
  end

  private

    def find_product
      @product = current_user.product
    end

    def product_params
      params.require(:product).permit(
        :email, :password, :password_confirmation,
        :name, :description, :price, :phone, :avatar, :opens_at, :closes_at,
        :category_id,
        :address, :latitude, :longitude,
        court_ids: [],
        profile_attributes: [:description],
        user_attributes: [:id, account_attributes: [:number, :company, :inn, :kpp, :agreement_number, :date, :bik]],
        courts_attributes: [:id, :name, :price, :change_price, :category_id, :_destroy],
        product_services_attributes: [:id, :periodic, :price, :_destroy, service_attributes: [:id, :name]]
      )
    end
end
