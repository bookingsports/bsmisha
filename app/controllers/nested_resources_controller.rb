class NestedResourcesController < ApplicationController
  before_action :find_product
  layout :set_layout

  def find_product
    @product  = (params[:scope] == "stadium") ? Stadium.friendly.find(params["stadium_id"]) : nil
    instance_variable_set("@#{params[:scope]}", @product)
  end

  def set_layout
    params[:scope]
  end
end
