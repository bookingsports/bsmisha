module WithdrawalConcern
  extend ActiveSupport::Concern

  included do
    rails_admin do
      parent Wallet
      visible false
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
      end
    end
  end
end