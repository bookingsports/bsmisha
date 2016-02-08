module DailyPriceRuleConcern
  extend ActiveSupport::Concern

  included do
    rails_admin do
      parent SpecialPrice
      list do
        field :special_price
        field :start
        field :stop
        field :price
        field :working_days
        field :created_at
        field :updated_at
      end

      edit do
        field :special_price
        field :start
        field :stop
        field :price
        field :working_days
        field :created_at
        field :updated_at
      end
    end
  end
end