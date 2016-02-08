module DepositRequestConcern
  extend ActiveSupport::Concern

  included do
    rails_admin do
      parent Deposit

      list do
        field :wallet
        field :status
        field :amount
        field :data
        field :created_at
        field :updated_at
      end

      edit do
        field :wallet
        field :status
        field :amount
        field :data
        field :created_at
        field :updated_at
      end
    end
  end
end