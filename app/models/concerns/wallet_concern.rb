module WalletConcern
  extend ActiveSupport::Concern

  included do
    rails_admin do
      list do
        field :user
        field :deposits
        field :deposit_requests
        field :withdrawals
        field :withdrawal_requests
        field :created_at
        field :updated_at
      end

      edit do
        field :event
        field :status
        field :summary
        field :order
        field :created_at
        field :updated_at
      end
    end
  end
end
