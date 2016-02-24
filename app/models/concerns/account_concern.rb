module AccountConcern
  extend ActiveSupport::Concern

  included do
    rails_admin do
      navigation_label I18n.t(:money)
      list do
        field :company
        field :number
        field :inn
        field :kpp
        field :bank
        field :bank_city
        field :bik
        field :kor
        field :created_at
        field :updated_at
      end

      show do
        field :company
        field :number
        field :inn
        field :kpp
        field :bank
        field :bank_city
        field :bik
        field :kor
        field :created_at
        field :updated_at
      end

      edit do
        field :company
        field :number
        field :inn
        field :kpp
        field :bank
        field :bank_city
        field :bik
        field :kor
      end
    end
  end
end
