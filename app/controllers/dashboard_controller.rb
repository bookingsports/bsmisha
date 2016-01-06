class DashboardController < ApplicationController
  before_filter :authenticate_user!
  layout "dashboard"

  def show
    @user = current_user
  end

  def grid
    @court = Court.friendly.find(params[:court_id]) rescue current_user.products.first
  end

  def payment_settings
  end
end
