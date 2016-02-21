class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  before_action :configure_permitted_params, if: :devise_controller?
  before_action :find_static_pages
  before_action :set_gon_user

  layout :set_layout

  protected

    def configure_permitted_params
      devise_parameter_sanitizer.for(:account_update) << [:name, :type, :phone]
      devise_parameter_sanitizer.for(:sign_up) << [:name, :type, :phone, :terms_agree]
    end

    def set_layout
      if current_user && devise_controller?
        "dashboard"
      end
    end

    def set_gon_user
      if user_signed_in?
        gon.current_user = {name: current_user.name}
      end
    end

    def find_static_pages
      @pages ||= StaticPage.all
    end

    def current_products
      nil
    end
end
