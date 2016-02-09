module ReviewConcern
  extend ActiveSupport::Concern

  included do
    rails_admin do
      parent Product
      list do
        field :reviewable
        field :text
        field :user
        field :verified
        field :rating
        field :created_at
        field :updated_at
      end

      edit do
        field :reviewable
        field :text
        field :user
        field :verified
        field :rating
        field :created_at
        field :updated_at
      end
    end
  end
end