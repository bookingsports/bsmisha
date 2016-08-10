module ServiceConcern
  extend ActiveSupport::Concern

  included do
    rails_admin do
      navigation_label I18n.t(:money)
      list do
        field :name
        field :icon
        field :price
        field :periodic
        field :stadium
        field :created_at
        field :updated_at
      end

      edit do
        field :name
        field :icon
        field :price
        field :periodic
        field :stadium
      end

      show do
        field :name
        field :icon
        field :price
        field :periodic
        field :stadium
        field :created_at
        field :updated_at
      end
    end
  end
end