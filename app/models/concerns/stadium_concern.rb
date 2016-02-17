module StadiumConcern
  extend ActiveSupport::Concern

  included do
    rails_admin do
      navigation_label I18n.t(:stadiums)
      navigation_icon 'icon-file'
      weight -1
      parent false

      list do
        field :name
        field :phone
        field :category
        field :owner
        field :slug
        field :address
        field :email
        field :description
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
        field :name
        field :phone
        field :category
        field :owner
        field :slug
        field :address
        field :email
        field :description, :ck_editor
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
