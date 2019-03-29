json.array! @events do |event|
  date_format = event.is_all_day? ? '%Y-%m-%d' : '%Y-%m-%dT%H:%M:%S'
  json.id event.id
  json.title (current_user.present? && (current_user.id == event.user_id || current_user.id == @stadium.user_id)) ? event.user.name : event.reason
  json.start event.start.strftime(date_format)
  json.end event.stop.strftime(date_format)
  json.resources event.area_id.to_s
  json.recurrence_rule event.recurrence_rule
  json.recurrence_exception event.recurrence_exception
  json.coach_id event.coach_id
  json.allDay event.is_all_day? ? true : false

  json.update_url event_path(event, method: :patch)
  json.edit_url edit_event_path(event)
end