module UserConcern
  extend ActiveSupport::Concern

  included do
    rails_admin do
      navigation_icon 'icon-user'
      visible false
      list do
        field :name
        field :email
        field :type
        field :avatar
        field :phone
      end

      edit do
        field :name
        field :email
        field :password
        field :password_confirmation
        field :avatar
        field :phone
      end
    end
  end
end
