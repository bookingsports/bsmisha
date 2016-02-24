module ServiceConcern
  extend ActiveSupport::Concern

  included do
    rails_admin do
      navigation_label I18n.t(:money)
      list do
        field :name
        field :icon
        field :products
        field :created_at
        field :updated_at
      end

      edit do
        field :name
        field :icon
        field :product_services
      end

      show do
        field :name
        field :icon
        field :products
        field :created_at
        field :updated_at
      end
    end
  end
end