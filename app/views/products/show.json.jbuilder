json.array! @product.stadium.services do |s|
  json.id s.id
  json.name s.service_name_and_price
end