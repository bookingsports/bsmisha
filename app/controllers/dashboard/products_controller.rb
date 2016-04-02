class Dashboard::ProductsController < DashboardController
  before_filter :find_product

  def edit
    gon.latLng = (current_user.kind_of? StadiumUser) ? {lat: @product.latitude || 55.75, lng: @product.longitude || 37.61} : nil
  end

  def update
    if @product.update product_params
      redirect_to edit_dashboard_product_url, notice: "Успешно сохранено"
    else
      render :edit
    end
  end

  def edit_account
  end

  private

    def find_product
      if current_user.kind_of? StadiumUser
        @product = current_user.stadium
      elsif current_user.coach.present?
        @product = current_user.coach
        @product.build_account if @product.account.blank?
      else
        @product = current_user.build_coach
        @product.build_account
      end
    end

    def product_params
      params.require(:product).permit(
        :email, :password, :password_confirmation,
        :name, :description, :price, :phone, :avatar, :main_image, :opens_at, :closes_at,
        :category_id,
        :address, :latitude, :longitude,
        area_ids: [],
        profile_attributes: [:description],
        user_attributes: [:id, :phone, :name, :avatar],
        account_attributes: [:id, :number, :company, :inn, :kpp, :agreement_number, :date, :bik],
        areas_attributes: [:id, :name, :price, :change_price, :category_id, :_destroy],
        stadium_services_attributes: [:id, :periodic, :price, :_destroy, service_attributes: [:id, :name, :_destroy]]
      )
    end
end
