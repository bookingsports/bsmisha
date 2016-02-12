module AdditionalEventItemConcern
  extend ActiveSupport::Concern

  included do
    rails_admin do
      parent Event
      visible false
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
      end
    end
  end
end