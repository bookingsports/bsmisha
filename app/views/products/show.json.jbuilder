json.array! @product.stadium.stadium_services do |ss|
  json.id ss.id
  json.name ss.service_name_and_price
end