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
        field :user
        field :slug
        field :account
        field :address
        field :email
        field :description
        field :pictures
        field :created_at
        field :updated_at
        field :main_image
        field :status
        field :opens_at do
          pretty_value do
            value.utc.strftime("%H:%M")
          end
        end
        field :closes_at do
          pretty_value do
            value.utc.strftime("%H:%M")
          end
        end
        field :closes_at
      end

      edit do
        field :name
        field :phone
        field :category
        field :user
        field :slug
        field :account
        field :address
        field :email
        field :description, :ck_editor
        field :pictures
        field :main_image
        field :status
        field :opens_at do
          formatted_value do
            value.utc.strftime("%H:%M")
          end
        end
        field :closes_at do
          formatted_value do
            value.utc.strftime("%H:%M")
          end
        end
        field :services
      end

      show do
        field :name
        field :phone
        field :category
        field :user
        field :slug
        field :account
        field :address
        field :email
        field :description
        field :pictures
        field :created_at
        field :updated_at
        field :main_image
        field :status
        field :opens_at do
          pretty_value do
            value.utc.strftime("%H:%M")
          end
        end
        field :closes_at do
          pretty_value do
            value.utc.strftime("%H:%M")
          end
        end
        field :services
      end
    end
  end
end
