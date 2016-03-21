json.array! @coaches_areas do |coaches_area|
  json.id coaches_area.coach.id
  json.name "#{coaches_area.coach.name} ( #{coaches_area.price} р.)"
end
