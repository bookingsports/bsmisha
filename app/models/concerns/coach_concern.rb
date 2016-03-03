module CoachConcern
  extend ActiveSupport::Concern

  included do
    rails_admin do
      navigation_label I18n.t(:stadiums)
      navigation_icon 'icon-file'
      parent false
      weight 1

      list do
        field :user
        field :description
        field :coaches_areas
        field :account
        field :created_at
        field :updated_at
      end

      show do
        field :user
        field :description
        field :coaches_areas
        field :account
        field :created_at
        field :updated_at
      end
      edit do
        field :user
        field :description
        field :coaches_areas
        field :account
      end
    end
  end
end
