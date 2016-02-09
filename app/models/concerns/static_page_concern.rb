module StaticPageConcern
  extend ActiveSupport::Concern

  included do
    rails_admin do
      list do
        field :title
        field :text
        field :slug
        field :created_at
        field :updated_at
      end

      edit do
        field :title
        field :text
        field :slug
        field :created_at
        field :updated_at
      end
    end
  end
end