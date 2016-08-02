module EventConcern
  extend ActiveSupport::Concern

  included do
    rails_admin do
      navigation_label I18n.t(:products)
      list do
        field :start
        field :stop
        field :status
        field :description
        field :user
        field :coach
        field :area
        field :created_at
        field :updated_at
        field :event_change
        field :user
      end

      show do
        field :start
        field :stop
        field :status
        field :description
        field :user
        field :coach
        field :area
        field :created_at
        field :updated_at
        field :event_change
        field :user
      end

      edit do
        field :start
        field :stop
        field :status
        field :description
        field :user
        field :coach
        field :area
        field :event_change
        field :user
      end
    end
  end
end
