class Users::RegistrationsController < Devise::RegistrationsController

  before_filter :configure_permitted_parameters

  def create
    build_resource(sign_up_params)
    if resource.class == StadiumUser
      resource.build_stadium sign_up_params[:stadium_attributes]
    end
    resource.save
    if resource.persisted?
      set_flash_message :notice, :signed_up
      sign_up(resource_name, resource)
      respond_with resource, location: root_url
    else
      clean_up_passwords resource
      set_minimum_password_length
      respond_with resource, location: root_url
    end
  end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up) { |u|
      u.permit(:type, :name, :email, :phone, :password, :password_confirmation, :current_password, :terms_agree, stadium_attributes: [:name, :address, :description, :opens_at, :closes_at, :category_id])
    }
  end

  def sign_up_params
    devise_parameter_sanitizer.sanitize(:sign_up)
  end
end