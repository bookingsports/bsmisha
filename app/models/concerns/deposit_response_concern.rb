module DepositResponseConcern
  extend ActiveSupport::Concern

  included do
    rails_admin do
      visible false
      list do
        field :deposit_request
        field :status
        field :data
        field :created_at
        field :updated_at
      end

      edit do
        field :deposit_request
        field :status
        field :data
      end
    end
  end
end