class NestedResourcesController < ApplicationController
  before_action :find_product
  layout :set_layout

  def find_product
    @product = Product.friendly.find(params["#{params[:scope]}_id"])
    instance_variable_set("@#{params[:scope]}", @product)
  end

  def set_layout
    params[:scope]
  end
end
