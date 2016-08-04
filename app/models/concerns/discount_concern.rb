module DiscountConcern
  extend ActiveSupport::Concern

  included do
    rails_admin do
      navigation_label I18n.t(:money)
      list do
        field :user
        field :area
        field :value
        field :created_at
        field :updated_at
      end

      show do
        field :user
        field :area
        field :value
        field :created_at
        field :updated_at
      end

      edit do
        field :user
        field :area
        field :value
      end
    end
  end
end
