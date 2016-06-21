json.array! @stadium.areas.each do |area|
  json.name area.name_with_stadium
  json.slug area.slug
  json.id area.id
end