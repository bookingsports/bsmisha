module PictureConcern
  extend ActiveSupport::Concern

  included do
    rails_admin do
      visible false

      object_label_method do
        :description
      end

      list do
        field :name
        field :description
        field :created_at
        field :updated_at
      end

      edit do
        field :name
        field :description
      end
    end
  end
end
