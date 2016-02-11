class Tennis.Views.CategorySelectorView extends Backbone.View
  events:
    'click .business-icon': 'setCategory'

  initialize: ->
    window.options.on('change:category', @render, this)

  render: ->
    @$el.find('.business-icon').removeClass('active')
    @$el.find(".#{@selectedCategory()}").addClass('active')

    this

  selectedCategory: ->
    window.options.get('category')

  setCategory: (e) ->
    category = $(e.currentTarget).data('category')
    window.options.set('category', category)

    window.markerCollection.category = category
    window.markerCollection.category.fetch()
