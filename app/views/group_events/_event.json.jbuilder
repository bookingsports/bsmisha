json.extract! event, :id, :recurrence_exception, :recurrence_id
date_format = event.is_all_day? ? '%Y-%m-%d' : '%Y-%m-%dT%H:%M:%S'
json.start event.start_for(current_user).strftime(date_format)
json.end event.stop_for(current_user).strftime(date_format)
json.recurrence_rule event.recurrence_rule
json.title event.name
json.kind event.kind.to_int
json.visual_type event.visual_type_for(current_user)
json.area_name event.area.try(:name)
json.area_name_with_stadium event.area.try(:name_with_stadium)
json.kendo_area_id event.area.try(:kendo_area_id).try(:to_s)
json.service_ids event.service_ids
json.coach_id event.coach_id
json.paid event.paid?
json.paid_transfer event.event_change.present? && event.event_change.paid?
json.reason "Занято"

json.update_url group_event_path(event, method: :patch)
json.edit_url edit_group_event_path(event)