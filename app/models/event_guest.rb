class EventGuest < ActiveRecord::Base
  belongs_to :event
  belongs_to :group_event
end
