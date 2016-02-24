module WithdrawalRequestConcern
  extend ActiveSupport::Concern

  included do
    rails_admin do
      parent Wallet
      list do
        field :wallet
        field :status
        field :amount
        field :data
        field :created_at
        field :updated_at
        field :payment
      end

      edit do
        field :wallet
        field :status
        field :amount
        field :data
        field :payment
      end
    end
  end
end