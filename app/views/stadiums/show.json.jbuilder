json.array! @stadium.areas.each do |area|
  json.name_with_stadium area.name_with_stadium
  json.name area.name
  json.stadium_slug area.stadium.slug
  json.slug area.slug
  json.id area.id
  json.kendo_id area.kendo_area_id
end