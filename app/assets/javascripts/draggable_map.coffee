#= require ./map_bundle

$ =>
  map = new Tennis.Views.DraggableMapView latLng: gon.latLng
  map.render()
