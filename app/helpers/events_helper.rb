# == Schema Information
#
# Table name: events
#
#  id                   :integer          not null, primary key
#  start                :datetime
#  stop                 :datetime
#  description          :string
#  coach_id             :integer
#  area_id              :integer
#  order_id             :integer
#  user_id              :integer
#  price                :float
#  recurrence_rule      :string
#  recurrence_exception :string
#  recurrence_id        :integer
#  is_all_day           :boolean
#  status               :integer          default(0)
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#

module EventsHelper
  def current_user_events_path
    if current_user.areas.any?
      dashboard_area_events_path(area_id: current_user.areas.first)
    end
  end
end
