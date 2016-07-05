module AreaConcern
  extend ActiveSupport::Concern

  included do
    before_destroy do
      coaches_areas.each do |ca|
        CoachesAreaMailer.area_destroyed_notify_coach(ca).deliver_now
      end
    end
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
