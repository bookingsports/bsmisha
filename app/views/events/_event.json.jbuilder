json.extract! event, :id, :recurrence_rule, :recurrence_exception, :recurrence_id
json.start event.start_for(current_user)
json.stop event.stop_for(current_user)
json.title event.user.name
json.visual_type event.visual_type_for(current_user)
json.area_name event.area.try(:name)
json.kendo_area_id event.area.try(:kendo_area_id).try(:to_s)
json.stadium_service_ids event.stadium_service_ids
json.coach_id event.coach_id
