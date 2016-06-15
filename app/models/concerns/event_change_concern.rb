module EventChangeConcern
  extend ActiveSupport::Concern

  included do
    rails_admin do
      parent Event
      visible false
      list do
        field :event
        field :order
        field :old_start
        field :old_stop
        field :new_start
        field :new_stop
        field :old_price
        field :created_at
        field :updated_at
      end

      edit do
        field :event
        field :order
        field :old_start
        field :old_stop
        field :new_start
        field :new_stop
        field :old_price
      end
    end
  end
end