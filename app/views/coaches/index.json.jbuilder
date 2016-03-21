json.array! @coaches_areas do |coaches_area|
  json.value coaches_area.coach.id
  json.text "#{coaches_area.coach.name} (#{coaches_area.price} р.)"
end
