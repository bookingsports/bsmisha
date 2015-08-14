class Tennis.Views.AllCourtsScheduleView extends Backbone.View
  initialize: (attrs) ->
    @mainUrl = attrs.url
    console.log @url()
    @bindExternalEvents()

  bindExternalEvents: ->
    $ =>
      scheduler = @scheduler()
      setInterval ->
        if !scheduler._editor.container
          scheduler.dataSource.read() 
          console.log('reload')
        else
          console.log('no reload')
      , 30000
      $('a[data-toggle="tab"]').on 'shown.bs.tab', (e) =>
        scheduler.refresh()
      $('#court').on 'change', =>
        scheduler.dataSource.read()
        scheduler.resources[1].dataSource.read()
      scheduler.wrapper.on 'mouseup touchend', '.k-scheduler-table td, .k-event', (e) ->
        target = $(e.currentTarget)
        if target.hasClass('k-event')
          event = scheduler.occurrenceByUid(target.data('uid'))
          scheduler.editEvent event
        else
          slot = scheduler.slotByElement(target[0])
          scheduler.addEvent
            start: slot.startDate
            end: slot.endDate
        return


  render: ->
    @$el.kendoScheduler({
      culture: 'ru-RU'
      date: new Date()
      startTime: new Date("2013/6/13 07:00 AM")
      height: 700
      views: [
        "day",
        {type: "week", selected: true},
        "month"
      ],

      edit: (e) =>
        # console.log e.event
        if (e.event.visual_type == 'disowned') || @getCookie('signed_in') != '1'
          alert('Пожалуйста, сначала авторизуйтесь.')
          e.preventDefault()
      resize: (e) =>
        if @timeIsOccupied(e.start, e.end, e.event)
          @scheduler().wrapper.find('.k-marquee-color').addClass 'invalid-slot'
          e.preventDefault()
        return
      resizeEnd: (e) =>
        if @timeIsOccupied(e.start, e.end, e.event)
          alert('Это время занято')
          e.preventDefault()
        return
      move: (e) =>
        if @timeIsOccupied(e.start, e.end, e.event)
          @scheduler().wrapper.find('.k-event-drag-hint').addClass 'invalid-slot'
        return
      moveEnd: (e) =>
        if @timeIsOccupied(e.start, e.end, e.event)
          alert('Это время занято')
          e.preventDefault()
        return
      add: (e) =>
        if @timeIsOccupied(e.event.start, e.event.end, e.event)
          alert('Это время занято')
          e.preventDefault()
        return
      save: (e) =>
        if @timeIsOccupied(e.event.start, e.event.end, e.event)
          alert('Это время занято')
          e.preventDefault()
        else
          e.sender.dataSource.one 'requestEnd', -> $.get(window.location.pathname + '/total.js')
        return
      resources:[
        {
          field: 'kendo_court_id'
          dataSource:[
            { text: '0', value: '0', color: '#1ABC9C' },
            { text: '1', value: '1', color: '#3498DB' },
            { text: '2', value: '2', color: '#34495E' },
            { text: '3', value: '3', color: '#E67E22' },
            { text: '4', value: '4', color: '#8ED869' },
            { text: '5', value: '5', color: '#ECF0F1' },
            { text: '6', value: '6', color: '#2ECC71' },
            { text: '7', value: '7', color: '#9B59B6' },
            { text: '8', value: '8', color: '#F1C40F' },
            { text: '9', value: '9', color: '#E74C3C' },
            { text: '10', value: '10', color: '#95A5A6' }
          ]
        },
      ]
      dataSource: {
        batch: false,
        transport: {
          read: {
            dataType: 'json',
            url: (e, s)=>
             @url() + '.json'
          },
          update: {
            dataType: 'json',
            url: (options) => "#{@url()}/#{options.id}",
            type: 'PUT'
          },
          create: {
            dataType: 'json',
            url: =>
             @url()
            type: 'POST'
          },
          destroy: {
            dataType: 'json',
            url: (options) => "#{@url()}/#{options.id}",
            method: 'DELETE'
        },
        parameterMap: (options, operation) =>
          if operation == "read"
            return options
          if operation != "read" && options
            return {event: options};
      },
      schema: {
        timezone: 'Europe/Moscow'
        model: {
          id: "id",
          fields: @fields
        },
        }
      }
    })

  scheduler: ->
    @$el.data('kendoScheduler')



  fields:
    title: { from: "court_name", type: 'string'},
    start: { type: "date", from: "start" },
    end: { type: "date", from: "end" },
    recurrenceId: { from: "recurrence_id" },
    recurrenceRule: { from: "recurrence_rule" },
    recurrenceException: { from: "recurrence_exception" },
    startTimezone: { from: "start_timezone" },
    endTimezone: { from: "end_timezone" },
    isAllDay: { type: "boolean", from: "is_all_day" }

  getCookie: (cname) ->
    name = cname + '='
    ca = document.cookie.split(';')
    i = 0
    while i < ca.length
      c = ca[i]
      while c.charAt(0) == ' '
        c = c.substring(1)
      if c.indexOf(name) == 0
        return c.substring(name.length, c.length)
      i++
    ''

  timeIsOccupied: (start, end, event) =>
    occurences = @scheduler().occurrencesInRange(start, end)
    idx = occurences.indexOf(event)
    if idx > -1
      occurences.splice(idx, 1)
    if occurences.length > 0
      true
    else
      false

  url: ->
    @mainUrl || window.location.pathname + '/events'
