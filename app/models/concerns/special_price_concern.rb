module SpecialPriceConcern
  extend ActiveSupport::Concern

  included do
    rails_admin do
      parent Product
      list do
        field :start
        field :stop
        field :price
        field :is_sale
        field :product
        field :daily_price_rules
        field :created_at
        field :updated_at
      end

      edit do
        field :start
        field :stop
        field :price
        field :is_sale
        field :product
        field :daily_price_rules
      end
    end
  end
end