json.array! @product.stadium.stadium_services do |ss|
  json.id ss.id
  json.name "#{ss.service.name} (#{ss.price} р.)"
end