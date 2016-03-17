module CoachesAreaConcern
  extend ActiveSupport::Concern

  included do
    rails_admin do
      parent Coach
      list do
        field :coach
        field :area
        field :price
      end

      show do
        field :coach
        field :area
        field :price
      end

      edit do
        field :coach
        field :area
        field :price
      end
    end
  end
end