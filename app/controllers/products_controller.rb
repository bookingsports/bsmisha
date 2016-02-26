# == Schema Information
#
# Table name: products
#
#  id           :integer          not null, primary key
#  category_id  :integer
#  user_id      :integer
#  name         :string
#  phone        :string
#  description  :text
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  address      :string
#  latitude     :float            default(55.75)
#  longitude    :float            default(37.61)
#  slug         :string
#  status       :integer          default(0)
#  type         :string
#  parent_id    :integer
#  email        :string
#  avatar       :string
#  price        :float
#  change_price :float
#  opens_at     :time
#  closes_at    :time
#

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
