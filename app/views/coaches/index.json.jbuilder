json.array! @coaches_areas do |coaches_area|
  json.id coaches_area.coach.id
  json.name coaches_area.coach.name
  json.price coaches_area.price
end
