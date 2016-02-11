module PictureConcern
  extend ActiveSupport::Concern

  included do
    rails_admin do
      visible false
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
