module WithdrawalRequestConcern
  extend ActiveSupport::Concern

  included do
    rails_admin do
      visible false
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
      end
    end
  end
end