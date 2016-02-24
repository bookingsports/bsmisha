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
        field :payment do
          formatted_value do
            (bindings[:view].link_to("Скачать",
              bindings[:view].main_app.print_dashboard_withdrawal_request_path(bindings[:object])))
          end
        end
      end

      show do
        field :wallet
        field :status
        field :amount
        field :data
        field :created_at
        field :updated_at
        field :payment do
          formatted_value do
            (bindings[:view].link_to("Скачать",
              bindings[:view].main_app.print_dashboard_withdrawal_request_path(bindings[:object])))
          end
        end
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