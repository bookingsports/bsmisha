class Tennis.Models.Marker extends Backbone.Model


class Tennis.Collections.MarkerCollection extends Backbone.Collection
  model: Tennis.Models.Marker
  url: -> "/businesses?category=#{@category}"
