module StaticPageConcern
  extend ActiveSupport::Concern

  included do
    rails_admin do
      navigation_label I18n.t(:website)
      navigation_icon 'icon-file'
      weight -3

      list do
        field :title
        field :slug
        field :text
        field :created_at
        field :updated_at
      end

      show do
        field :title
        field :slug
        field :text do
          formatted_value do
            bindings[:view].raw value
          end
        end
        field :created_at
        field :updated_at
      end

      edit do
        field :title
        field :slug
        field :text, :ck_editor
      end
    end
  end
end
