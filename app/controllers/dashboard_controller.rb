class DashboardController < ApplicationController
  before_filter :authenticate_user!
  layout "dashboard"

  def show
    @user = current_user
  end

  def grid
    @area = Area.friendly.find(params[:area_id]) rescue current_user.products.first
    set_gon_area
  end

  def payment_settings
  end
end
