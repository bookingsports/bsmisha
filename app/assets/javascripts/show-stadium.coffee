    :javascript
      var markers = new Tennis.Collections.MarkerCollection([#{raw stadium.to_json}]);
      var map = new Tennis.Views.MapView({collection: markers});
      map.render();
