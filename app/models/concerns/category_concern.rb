module CategoryConcern
  extend ActiveSupport::Concern

  included do
    rails_admin do
      list do
        field :name
        field :ancestry
        field :slug
        field :icon
        field :created_at
        field :updated_at
      end

      edit do
        field :name
        field :ancestry
        field :slug
        field :icon
        field :created_at
        field :updated_at
      end
    end
  end
end