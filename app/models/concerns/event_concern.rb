module EventConcern
  extend ActiveSupport::Concern

  included do
    rails_admin do
      navigation_label I18n.t(:products)
      list do
        field :start
        field :end
        field :description
        field :products
        field :order
        field :created_at
        field :updated_at
        field :recurrence_rule
        field :recurrence_exception
        field :recurrence_id
        field :additional_event_items
        field :event_changes
        field :is_all_day
        field :user
      end

      edit do
        field :start
        field :end
        field :description
        field :products
        field :order
        field :additional_event_items
        field :event_changes
        field :is_all_day
        field :user
      end
    end
  end
end
