module CoachesCourtConcern
  extend ActiveSupport::Concern

  included do
    rails_admin do
      parent Coach
      list do
        field :coach
        field :court
        field :price
        field :created_at
        field :updated_at
      end

      show do
        field :coach
        field :court
        field :price
        field :created_at
        field :updated_at
      end

      edit do
        field :coach
        field :court
        field :price
      end
    end
  end
end