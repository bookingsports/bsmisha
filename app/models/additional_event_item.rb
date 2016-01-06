class AdditionalEventItem < ActiveRecord::Base
  belongs_to :event
  belongs_to :related, polymorphic: true

  scope :coach, -> { where("related_type = ?", "User") }
  scope :not_coach, -> { where("related_type <> ?", "User") }

  def total
    (related.price.to_i * amount.to_i).to_i
  end

  def payment_receiver
    if related.kind_of? Coach
      related
    else
      event.stadium.user
    end
  end
end
