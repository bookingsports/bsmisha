module ProductConcern
  extend ActiveSupport::Concern

  included do
    rails_admin do
      navigation_label I18n.t(:products)
      list do
        field :category
        field :owner
        field :email
        field :description
        field :type
        field :latitude
        field :longitude
        field :pictures
        field :created_at
        field :updated_at
        field :avatar
        field :status
        field :price
        field :opens_at
        field :closes_at
      end

      edit do
        field :category
        field :owner
        field :email
        field :description
        field :type
        field :latitude
        field :longitude
        field :pictures
        field :avatar
        field :status
        field :price
        field :opens_at
        field :closes_at
      end
    end
  end
end
