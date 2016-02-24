module AdminConcern
  extend ActiveSupport::Concern

  included do
    rails_admin do
      navigation_label I18n.t("users_types")
      parent false
      weight 1

      list do
        field :name
        field :email
        field :avatar
        field :phone
      end

      show do
        field :name
        field :email
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
