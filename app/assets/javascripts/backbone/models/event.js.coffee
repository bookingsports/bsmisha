class Tennis.Models.Event extends Backbone.Model
  eventObject: ->
    title: @attributes.title
    start: @attributes.start
    end: @attributes.end
    color: 'red' if @isOverlapping()
    editable: true
    cid: @cid

  isOverlapping: ->
    array = window.grid.$el.fullCalendar('clientEvents')
    for event in array
      if event.id != @attributes.id
        if event.start < @attributes.end && event.end > @attributes.start
          return true
    return false

class Tennis.Collections.Events extends Backbone.Collection
  paramRoot: 'order'
