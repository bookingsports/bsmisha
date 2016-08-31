module PictureConcern
  extend ActiveSupport::Concern

  included do
    rails_admin do
      navigation_label I18n.t(:products)

      object_label_method do
        :description
      end

      list do
        field :name
        field :description
        field :created_at
        field :updated_at
        field :imageable
      end

      edit do
        field :name
        field :description
        field :imageable
      end
    end
  end
end
