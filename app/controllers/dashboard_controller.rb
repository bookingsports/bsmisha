class DashboardController < ApplicationController
  before_filter :authenticate_user!
  layout "dashboard"

  def show
    @user = current_user
  end

  def grid
    if current_user.type == "Customer"
      @areas = current_user.events.past.map(&:area).uniq
    elsif params[:area_id].present?
      @area = Area.friendly.find(params[:area_id]) rescue current_user.product_areas.first
    else
      @areas = current_user.product_areas
    end
    set_gon_area
  end

  def payment_settings
  end
end
