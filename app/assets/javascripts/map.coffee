#= require ./map_bundle

$ =>
  markers = new Tennis.Collections.MarkerCollection gon.markers

  window.map = new Tennis.Views.MapView collection: markers

  stadium_names = markers.models.map (el) => el.attributes.name

  map.render()

  config = {
    '.chosen-select': {},
    '.chosen-select-deselect': {allow_single_deselect: true},
    '.chosen-select-no-single': {disable_search_threshold: 10},
    '.chosen-select-no-results': {no_results_text: 'Oops, nothing found!'},
    '.chosen-select-width': {width: "95%"}
  }

  for selector in config
    $(selector).chosen(config[selector])

  $('#q_name_cont').autocomplete source: stadium_names
