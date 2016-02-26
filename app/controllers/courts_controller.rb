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

class CourtsController < ApplicationController
  layout :set_layout
  before_filter :set_scope

  def index
  end

  def show
    @court = Court.friendly.find params[:id]
    set_gon_court
  end

  def total
    @court = Court.friendly.find(params[:id])
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
