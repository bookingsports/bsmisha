module CategoryConcern
  extend ActiveSupport::Concern

  included do
    rails_admin do
      navigation_label I18n.t(:stadiums)
      navigation_icon 'icon-list'
      weight -2

      nestable_tree({position_field: :position, max_depth: 3})

      list do
        sort_by :position
        field :name do
          pretty_value do
            "#{'-'*bindings[:object].depth*3} #{bindings[:object].name}"
          end
        end
        field :parent_id, :enum do
          enum_method do
            :parent_enum
          end
        end
        field :slug
        field :icon
        field :main_image
        field :created_at
        field :updated_at
      end

      show do
        field :name do
          pretty_value do
            "#{'-'*bindings[:object].depth*3} #{bindings[:object].name}"
          end
        end
        field :parent_id, :enum do
          enum_method do
            :parent_enum
          end
        end
        field :slug
        field :icon
        field :main_image
        field :created_at
        field :updated_at
      end

      edit do
        field :name
        field :slug
        field :icon
        field :main_image
      end
    end
  end
end
