module ReviewConcern
  extend ActiveSupport::Concern

  included do
    rails_admin do
      navigation_label I18n.t(:products)
      list do
        field :reviewable
        field :text
        field :user
        field :verified
        field :rating
        field :created_at
        field :updated_at
      end

      show do
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
      end
    end
  end
end