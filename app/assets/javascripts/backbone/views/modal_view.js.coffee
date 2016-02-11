class Tennis.Views.ModalView extends Backbone.View
  events: ->
    'show':           'modalWillShow'
    'show.bs.modal':  'modalWillShow'
    'shown':          'modalDidShow'
    'shown.bs.modal': 'modalDidShow'
    'hide':           'modalWillHide'
    'hide.bs.modal':  'modalWillHide'
    'hidden':         'modalDidHide'

  variables: -> {}
  template: JST['backbone/templates/default_modal']
  render: ->
    if $('body')[0].contains(@el)
      @$el.remove()

    $modal = $(@template(@variables())).attr(id: @id)
    $modal.appendTo('body')
          .modal(keyboard: true, backdrop: @backdrop)

    @setElement $modal, true

    $modal.find('.modal-dialog').css(@dialogStyle) if @dialogStyle
    $modal.modal('show')
    @afterRender() if @afterRender

  renderContent: ->
    html = $(@template(@variables))

    @$el.html(html.html())


  hide: ->
    @$el.modal('hide')

  show: ->
    @$el.modal('show')

  modalWillShow: ->
    @trigger('willShow')

  modalDidShow: ->
    @trigger('didShow')

  modalWillHide: ->
    @trigger('willHide')

  modalDidHide: ->
    @trigger('didHide')
