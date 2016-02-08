# == Schema Information
#
# Table name: additional_event_items
#
#  id           :integer          not null, primary key
#  related_id   :integer
#  related_type :string
#  event_id     :integer
#  amount       :integer          default(1)
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

class AdditionalEventItem < ActiveRecord::Base
  include AdditionalEventItemConcern
  has_paper_trail
  
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
