class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  before_action :configure_permitted_params, if: :devise_controller?
  before_action :find_static_pages
  before_action :set_gon_user

  layout :set_layout

  rescue_from ActiveRecord::RecordNotFound, :with => :record_not_found
  rescue_from ActionController::RoutingError, :with => :record_not_found
  def record_not_found
    render :template => "errors/not_found", :status => 404
    true
  end

  rescue_from CanCan::AccessDenied do |exception|
    redirect_to "/", alert: "Вы не можете просматривать данную страницу."
  end

  protected

    def configure_permitted_params
      devise_parameter_sanitizer.permit(:account_update,keys: [:name, :type, :phone, :avatar])
      devise_parameter_sanitizer.permit(:sign_up, keys: [:name, :type, :phone, :terms_agree, :avatar])
    end

    def set_layout
      if current_user && devise_controller?
        "dashboard"
      end
    end

    def set_gon_user
      if user_signed_in?
        gon.current_user = {name: current_user.name, type: current_user.type, stadium: current_user.stadium, areas: current_user.area_ids}
      end
    end

    def set_markers(stadiums)
      gon.markers = JSON.parse(VisitorsController.new.render_to_string(
          locals: { stadiums: stadiums },
          template: 'stadiums/_markers',
          formats: 'json',
          layout: false))['markers']
    end

    def find_static_pages
      @pages ||= StaticPage.all
    end

    def set_gon_area
      if @area
        gon.area_id = @area.id
        gon.opens_at = Time.zone.parse(@area.stadium.opens_at.to_s)
        gon.closes_at = Time.zone.parse(@area.stadium.closes_at.to_s)
        gon.area_my_events_path = area_my_events_path(@area)
      elsif @areas
        gon.opens_at = Time.zone.parse(@areas.map(&:stadium).map(&:opens_at).min.to_s)
        gon.closes_at = Time.zone.parse(@areas.map(&:stadium).map(&:closes_at).max.to_s)
      end
    end

    def current_products
      nil
    end
end
