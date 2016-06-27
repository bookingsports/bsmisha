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

      show do
        field :user
        field :deposits do
          pretty_value do
            bindings[:view].render partial: "rails_admin/deposits", locals: {field: self, object: bindings[:object] }
          end
        end
        field :deposit_requests do
          pretty_value do
            bindings[:view].render partial: "rails_admin/deposit_requests", locals: {field: self, object: bindings[:object] }
          end
        end
        field :withdrawals do
          pretty_value do
            bindings[:view].render partial: "rails_admin/withdrawals", locals: {field: self, object: bindings[:object] }
          end
        end
        field :withdrawal_requests do
          pretty_value do
            bindings[:view].render partial: "rails_admin/withdrawal_requests", locals: {field: self, object: bindings[:object] }
          end
        end
        field :withdrawal_requests
        field :created_at
        field :updated_at
      end

      edit do
        field :user
        field :deposits
        field :deposit_requests
        field :withdrawals
        field :withdrawal_requests
      end
    end
  end
end
