module OrderConcern
  extend ActiveSupport::Concern

  included do
    rails_admin do
      parent User
      list do
        field :user
        field :total
        field :status
        field :comment
        field :created_at
        field :updated_at
      end

      edit do
        field :user
        field :total
        field :status
        field :comment
        field :created_at
        field :updated_at
      end
    end
  end
end