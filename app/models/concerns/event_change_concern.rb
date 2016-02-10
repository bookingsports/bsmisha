module EventChangeConcern
  extend ActiveSupport::Concern

  included do
    rails_admin do
      parent Event
      list do
        field :event
        field :status
        field :summary
        field :order
        field :created_at
        field :updated_at
      end

      edit do
        field :event
        field :status
        field :summary
        field :order
        field :created_at
        field :updated_at
      end
    end
  end
end