class AdminController < ApplicationController
  before_action :authenticate_admin!

  private

    def authenticate_admin!
      authenticate_user!
      redirect_to root_path, alert: 'Этот раздел только для администраторов, извините.' unless current_user.admin?
    end
end