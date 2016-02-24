module StadiumUserConcern
  extend ActiveSupport::Concern

  included do
    rails_admin do
      navigation_icon 'icon-user'
      parent Stadium
      list do
        field :name
        field :email
        field :avatar
        field :account
        field :status
        field :wallet
        field :phone
      end

      edit do
        field :name
        field :email
        field :password
        field :password_confirmation
        field :avatar
        field :account
        field :wallet
        field :status
        field :phone
      end
    end
  end
end
