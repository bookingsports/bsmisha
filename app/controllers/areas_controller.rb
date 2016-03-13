# == Schema Information
#
# Table name: areas
#
#  id           :integer          not null, primary key
#  stadium_id   :integer
#  name         :string
#  description  :string
#  slug         :string
#  change_price :decimal(, )      default(0.0)
#  created_at   :datetime
#  updated_at   :datetime
#

class AreasController < ApplicationController
  layout :set_layout
  before_filter :set_scope

  def index
  end

  def show
    @area = Area.friendly.find params[:id]
    set_gon_area
  end

  def total
    @area = Area.friendly.find(params[:id])
    respond_to do |format|
      format.js {}
    end
  end

  private

    def set_layout
      params[:scope] || "application"
    end

    def set_scope
      if params[:scope]
        scope = params[:scope]
        record = scope.classify.constantize.friendly.find params[scope+"_id"] || params[:id]
        instance_variable_set("@"+params[:scope], record)
        instance_variable_set("@product", record)
      end
    end
end
