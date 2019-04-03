class EventGuest < ActiveRecord::Base
  belongs_to :event
  belongs_to :group_event
  enum status: [:unconfirmed, :confirmed, :paid]
  scope :future, -> { where arel_table['start'].gt Time.now }
  belongs_to :user, class_name: "User"
end
