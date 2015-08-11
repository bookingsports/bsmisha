class Tennis.Views.ScheduleView extends Backbone.View
  initialize: (attrs) ->
    # @model = new Tennis.Models.Event()
    # @collection = new Tennis.Collections.Events()
    @mainUrl = attrs.url
    @court_id = attrs.court
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
          field: 'visual_type'
          dataSource:[
            { text: 'Своё', value: 'owned', color: 'cadetblue', editable: false },
            { text: 'Чужое', value: 'disowned', color: '#ccc' },
            { text: 'Оплачено', value: 'paid', color: '#8ED869' }
          ]
        },
        {
          field: 'product_service_ids',
          title: "Дополнительные услуги",
          multiple: true,
          dataTextField: 'service_name_and_price',
          dataValueField: 'id'
          dataSource: {
            transport: {
              read: {
                url: => "/products/#{@court_id}.json"
              },
              parameterMap: (options, operation) ->
                return options.product_services
            },
            schema: {
              data: (resp) ->
                resp.product_services
            }
          }
        }  
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
    title: { from: "description", type: 'string'},
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
