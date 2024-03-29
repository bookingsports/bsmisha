module CustomerConcern
  extend ActiveSupport::Concern

  included do
    rails_admin do
      navigation_label I18n.t(:money)
      navigation_icon 'icon-user'
      parent false
      weight -2

      list do
        field :name
        field :email
        field :avatar
        field :phone
        field :events
        field :wallet
      end

      show do
        field :name
        field :email
        field :avatar
        field :phone
        field :events
        field :wallet
      end

      edit do
        field :name
        field :email
        field :password
        field :password_confirmation
        field :avatar
        field :phone
        field :events
        field :wallet
      end
    end
  end
end
