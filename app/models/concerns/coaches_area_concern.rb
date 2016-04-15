module CoachesAreaConcern
  extend ActiveSupport::Concern

  included do
    rails_admin do
      parent Coach
      list do
        field :coach
        field :area
        field :price
        field :status
        field :stadium_percent
      end

      show do
        field :coach
        field :area
        field :price
        field :status
        field :stadium_percent
      end

      edit do
        field :coach
        field :area
        field :price
        field :status
        field :stadium_percent
      end
    end
  end
end