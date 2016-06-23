#= require gmaps/google
#= require ./backbone/models/marker
#= require ./backbone/views/map_view
#= require ./backbone/views/map_views/draggable_map_view

class window.CustomMarkerBuilder extends Gmaps.Google.Builders.Marker
  create_marker: ->
    @args.infowindow = @args.attributes.infowindow
    options = _.extend @marker_options(@args.attributes), @custom_options()
    @serviceObject = new(@primitives().marker)(options)

  addMarkers: ->
    @args.infowindow = @args.attributes.infowindow
    options = _.extend @marker_options(@args.attributes), @custom_options()
    @serviceObject = new(@primitives().marker)(options)

  custom_options: ->
    {
      icon: @args.attributes.icon
      draggable: @args.attributes.draggable
      position: @args.attributes.position
      opacity: @args.attributes.opacity
    }

