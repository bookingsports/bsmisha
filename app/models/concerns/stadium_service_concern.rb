module StadiumServiceConcern
  extend ActiveSupport::Concern

  included do
    rails_admin do
      parent Service
      visible false
      list do
        field :stadium
        field :service
        field :price
        field :created_at
        field :updated_at
      end

      show do
        field :stadium
        field :service
        field :price
        field :created_at
        field :updated_at
      end

      edit do
        field :stadium
        field :service
        field :price
      end
    end
  end
end
