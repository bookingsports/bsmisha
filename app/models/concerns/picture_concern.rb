module PictureConcern
  extend ActiveSupport::Concern

  included do
    rails_admin do
      list do
        field :name
        field :imageable
        field :description
        field :created_at
        field :updated_at
      end

      edit do
        field :name
        field :imageable
        field :description
      end
    end
  end
end
