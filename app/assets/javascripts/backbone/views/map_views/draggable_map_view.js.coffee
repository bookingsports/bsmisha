class Tennis.Views.DraggableMapView extends Tennis.Views.MapView
  initialize: (params={}) ->
    marker = new Tennis.Models.Marker
      position: params.latLng || @moscowCoords()
      draggable: true
      title: 'Переместите меня!'
    @collection = new Tennis.Collections.MarkerCollection [marker]
    super

  afterMap: ->
    google.maps.event.addListener @markers[0].serviceObject, 'dragend', (event) =>
      @submitPos(`this.getPosition()`)

    #google.maps.event.addListener @handler.getMap(), 'click', (event) =>
    #  @markers[0].serviceObject.setPosition(event.latLng)
    #  @submitPos(event.latLng)

  submitPos: (pos) ->
    $('#product_latitude').val(pos.lat())
    $('#product_longitude').val(pos.lng())

    #@geocoder.geocode {latLng: pos}, (t, i) ->
    #  if (i != google.maps.GeocoderStatus.OK)
    #      return console.log("Geocoder failed due to: " + i)
    #  if (!t[0])
    #      return console.log("No results found")
    #  a = t[0]
    #  $('#product_address').val(a.formatted_address)
