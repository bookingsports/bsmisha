module AccountConcern
  extend ActiveSupport::Concern

  included do
    rails_admin do
      navigation_label I18n.t(:money)
      list do
        field :accountable
        field :company
        field :number
        field :inn
        field :kpp
        field :agreement_number
        field :date
        field :bik
        field :merchant_id
        field :created_at
        field :updated_at
      end

      show do
        field :accountable
        field :company
        field :number
        field :inn
        field :kpp
        field :agreement_number
        field :date
        field :bik
        field :merchant_id
        field :created_at
        field :updated_at
      end

      edit do
        field :accountable
        field :company
        field :number
        field :inn
        field :kpp
        field :agreement_number
        field :date
        field :bik
        field :merchant_id
      end
    end
  end
end
