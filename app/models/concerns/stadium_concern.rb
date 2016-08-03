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
        field :areas
        field :account
        field :address
        field :latitude
        field :longitude
        field :email
        field :description
        field :pictures
        field :created_at
        field :updated_at
        field :main_image
        field :status
        field :opens_at do
          pretty_value do
            value.present? ? value.utc.strftime("%H:%M") : ""
          end
        end
        field :closes_at do
          pretty_value do
            value.present? ? value.utc.strftime("%H:%M") : ""
          end
        end
      end

      edit do
        field :name
        field :phone
        field :category
        field :slug
        field :areas
        field :account
        field :address
        field :latitude
        field :longitude
        field :email
        field :description, :text do
          html_attributes do
            {rows: 15, cols: 60}
          end
        end
        field :pictures
        field :main_image
        field :status
        field :opens_at do
          formatted_value do
            value.present? ? value.utc.strftime("%H:%M") : Time.parse("07:00")
          end
        end
        field :closes_at do
          formatted_value do
            value.present? ? value.utc.strftime("%H:%M") : Time.parse("23:00")
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
        field :areas
        field :account
        field :address
        field :latitude
        field :longitude
        field :email
        field :description
        field :pictures
        field :created_at
        field :updated_at
        field :main_image
        field :status
        field :opens_at do
          pretty_value do
            value.present? ? value.utc.strftime("%H:%M") : ""
          end
        end
        field :closes_at do
          pretty_value do
            value.present? ? value.utc.strftime("%H:%M") : ""
          end
        end
        field :services
      end
    end
  end
end
