class Dashboard::ProductsController < DashboardController
  before_filter :find_product

  def edit
    gon.latLng = (current_user.kind_of? StadiumUser) ? {lat: @product.latitude || 55.75, lng: @product.longitude || 37.61} : nil
  end

  def update
    begin
      if @product.update product_params
        #if product_params[:account_attributes].present?
        #  redirect_to edit_account_dashboard_product_url, notice: "Успешно сохранено"
        #elsif product_params[:areas_attributes].present? && product_params[:areas_attributes][:recoupments_attributes].present?
        #  redirect_to edit_recoupments_dashboard_product_url, notice: "Успешно сохранено"
        #else
        #  redirect_to edit_dashboard_product_url, notice: "Успешно сохранено"
        #end
        redirect_to :back, notice: "Успешно сохранено"
      else
        render :edit
      end
    rescue ActiveRecord::RecordNotDestroyed => invalid
      redirect_to (product_params[:account_attributes].present? ? edit_account_dashboard_product_url : edit_dashboard_product_url), alert: "Нельзя удалить площадку, у которой еще есть заказы!"
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
        areas_attributes: [:id, :name, :price, :change_price, :category_id, :_destroy, recoupments_attributes: [:id, :user_id, :_destroy, :area_id, :price, :reason]],
        stadium_services_attributes: [:id, :periodic, :price, :_destroy, service_attributes: [:id, :name, :_destroy]],
      )
    end
end
