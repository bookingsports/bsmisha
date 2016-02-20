module CoachUserConcern
  extend ActiveSupport::Concern

  included do
    rails_admin do
      navigation_label I18n.t("users_types")
      parent false
      list do
        field :name
        field :email
        field :avatar
        field :account
        field :phone
        field :wallet
      end

      show do
        field :name
        field :email
        field :avatar
        field :account
        field :phone
        field :wallet
      end

      edit do
        field :name
        field :email
        field :password
        field :password_confirmation
        field :avatar
        field :account
        field :phone
      end
    end
  end
end