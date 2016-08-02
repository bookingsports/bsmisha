module EventChangeConcern
  extend ActiveSupport::Concern

  included do
    rails_admin do
      parent Event
      list do
        field :event
        field :status
        field :old_start
        field :old_stop
        field :new_start
        field :new_stop
        field :new_price
        field :created_at
        field :updated_at
      end

      edit do
        field :event
        field :status
        field :old_start
        field :old_stop
        field :new_start
        field :new_stop
        field :new_price
      end
    end
  end
end