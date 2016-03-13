module RecoupmentConcern
  extend ActiveSupport::Concern

  included do
    rails_admin do
      navigation_label I18n.t(:money)
      list do
        field :duration
        field :user
        field :area
        field :reason
        field :created_at
        field :updated_at
      end

      show do
        field :duration
        field :user
        field :area
        field :reason
        field :created_at
        field :updated_at
      end

      edit do
        field :duration
        field :user
        field :area
        field :reason
      end
    end
  end
end
