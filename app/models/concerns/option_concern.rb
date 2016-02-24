module OptionConcern
  extend ActiveSupport::Concern

  included do
    rails_admin do
      visible false
      list do
        field :tax
        field :feedback_email
        field :created_at
        field :updated_at
      end

      edit do
        field :tax
        field :feedback_email
        field :created_at
        field :updated_at
      end
    end
  end
end