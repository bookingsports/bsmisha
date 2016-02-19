module ProductServiceConcern
  extend ActiveSupport::Concern

  included do
    rails_admin do
      parent Service
      list do
        field :product
        field :service
        field :price
        field :created_at
        field :updated_at
      end

      show do
        field :product
        field :service
        field :price
        field :created_at
        field :updated_at
      end

      edit do
        field :product
        field :service
        field :price
      end
    end
  end
end
