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
        field :opens_at
        field :closes_at
        field :stadium
        field :events
        field :created_at
        field :updated_at
      end

      edit do
        field :name
        field :description
        field :opens_at
        field :closes_at
        field :stadium
        field :events
      end

      show do
field :name
        field :description
        field :opens_at
        field :closes_at
        field :stadium
        field :events
        field :created_at
        field :updated_at
      end
    end
  end
end
