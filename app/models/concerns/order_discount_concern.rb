module OrderDiscountConcern
  extend ActiveSupport::Concern

  included do
    rails_admin do
      navigation_label I18n.t(:money)
      list do
        field :area
        field :start
        field :value
        field :created_at
        field :updated_at
      end

      show do
        field :area
        field :start
        field :value
        field :created_at
        field :updated_at
      end

      edit do
        field :area
        field :start
        field :value
      end
    end
  end
end
