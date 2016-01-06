class ProductsController < ApplicationController
  layout "dashboard"

  def show
    @product = Product.friendly.find params[:id]

    respond_to do |format|
      format.json { render json: @product.to_json(include: {product_services: {methods: :service_name_and_price}}) }
      format.html {  }
    end
  end
end
