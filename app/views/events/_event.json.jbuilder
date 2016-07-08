json.extract! event, :id, :recurrence_rule, :recurrence_exception, :recurrence_id
json.start event.start_for(current_user)
json.stop event.stop_for(current_user)
json.title event.reason.present? ? event.reason : event.user.name
json.visual_type event.visual_type_for(current_user)
json.area_name event.area.try(:name)
json.area_name_with_stadium event.area.try(:name_with_stadium)
json.kendo_area_id event.area.try(:kendo_area_id).try(:to_s)
json.stadium_service_ids event.stadium_service_ids
json.coach_id event.coach_id
json.paid event.paid?
json.paid_transfer event.event_change.present? && event.event_change.paid?