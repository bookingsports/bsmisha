module AreaConcern
  extend ActiveSupport::Concern

  included do
    rails_admin do
      navigation_label I18n.t(:stadiums)
      navigation_icon 'icon-file'
      weight 0
      parent false

      object_label_method do
        :display_name
      end
      list do
        field :name
        field :description
        field :stadium
        field :events
        field :coaches_areas
        field :slug
        field :created_at
        field :updated_at
      end

      edit do
        field :name
        field :description
        field :stadium
        field :events
        field :coaches_areas
        field :slug
      end

      show do
        field :name
        field :description
        field :stadium
        field :events
        field :coaches_areas
        field :slug
        field :created_at
        field :updated_at
      end
    end
  end
end
