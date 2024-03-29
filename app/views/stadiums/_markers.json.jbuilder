json.markers do
  json.(stadiums) do |s|
    json.icon asset_path(stadium_get_category_icon(s))
    json.position do
      json.lat s.latitude.to_f
      json.lng s.longitude.to_f
    end
    json.name s.name
    json.opacity (s.active? ? 1 : 0.5)
    json.infowindow stadium_infowindow(s)
  end
end
