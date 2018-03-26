json.array! @group_events do |event|
  date_format = event.is_all_day? ? '%Y-%m-%d' : '%Y-%m-%dT%H:%M:%S'
  json.id event.id
  json.title event.name
  json.start event.start.strftime(date_format)
  json.end event.stop.strftime(date_format)
  json.resources event.area_id.to_s
  json.recurrence_rule event.recurrence_rule
  json.recurrence_exception event.recurrence_exception
  json.coach_id event.coach_id
  json.allDay event.is_all_day? ? true : false

  json.update_url group_event_path(event, method: :patch)
  json.edit_url edit_group_event_path(event)
end