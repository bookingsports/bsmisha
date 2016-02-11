module WalletConcern
  extend ActiveSupport::Concern

  included do
    rails_admin do
      navigation_label I18n.t(:money)
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
        field :user
      end
    end
  end
end
