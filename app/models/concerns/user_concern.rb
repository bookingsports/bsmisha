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
        field :status
        field :phone
      end

      edit do
        field :name
        field :email
        field :password
        field :password_confirmation
        field :avatar
        field :status
        field :phone
      end
    end
  end
end
