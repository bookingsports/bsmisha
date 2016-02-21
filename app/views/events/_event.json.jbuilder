json.extract! event, :id, :recurrence_rule, :recurrence_exception, :recurrence_id
json.start event.start_for(current_user)
json.end event.end_for(current_user)
json.title event.user.name
json.visual_type event.visual_type_for(current_user)
json.court_name event.court.try(:name)
json.kendo_court_id event.court.try(:kendo_court_id).try(:to_s)
json.product_service_ids event.product_service_ids
