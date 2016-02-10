module DepositConcern
  extend ActiveSupport::Concern

  included do
    rails_admin do
      parent Wallet
      list do
        field :wallet
        field :status
        field :amount
        field :created_at
        field :updated_at
      end

      edit do
        field :wallet
        field :status
        field :amount
        field :created_at
        field :updated_at
      end
    end
  end
end