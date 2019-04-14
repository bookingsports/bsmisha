class EventGuest < ActiveRecord::Base
  belongs_to :event
  belongs_to :group_event
  enum status: [:unconfirmed, :confirmed, :paid]
  scope :future, -> { where arel_table['start'].gt Time.now }
  belongs_to :user, class_name: "User"
  validate :already_enrollment

  def already_enrollment
   if self.group_event.event_guests.where(:email => self.email).present?
    errors.add(:event_guests, "Пользователь " + self.email + " уже записан на занятие")
   end
  end
end
