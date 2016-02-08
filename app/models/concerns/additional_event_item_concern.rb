module AdditionalEventItemConcern
  extend ActiveSupport::Concern

  included do
    rails_admin do
      parent Event
      list do
        field :related
        field :event
        field :amount
        field :created_at
        field :updated_at
      end

      edit do
        field :related
        field :event
        field :amount
        field :created_at
        field :updated_at
      end
    end
  end
end