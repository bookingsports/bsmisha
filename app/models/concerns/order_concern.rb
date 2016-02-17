module OrderConcern
  extend ActiveSupport::Concern

  included do
    rails_admin do
      navigation_label I18n.t(:money)
      weight 0

      list do
        field :user
        field :total
        field :status
        field :comment
        field :events
        field :event_changes
        field :created_at
        field :updated_at
      end

      edit do
        field :user
        field :total
        field :status
        field :events
        field :event_changes
        field :comment
      end
    end
  end
end
