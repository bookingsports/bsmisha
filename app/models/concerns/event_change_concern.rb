module EventChangeConcern
  extend ActiveSupport::Concern

  included do
    rails_admin do
      parent Event
      visible false
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
      end
    end
  end
end