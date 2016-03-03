module DailyPriceRuleConcern
  extend ActiveSupport::Concern

  included do
    rails_admin do
      parent Price
      visible false
      list do
        field :price
        field :start
        field :stop
        field :price
        field :working_days
        field :created_at
        field :updated_at
      end

      edit do
        field :price
        field :start
        field :stop
        field :price
        field :working_days
      end
    end
  end
end