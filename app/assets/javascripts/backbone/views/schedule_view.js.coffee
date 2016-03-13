class Tennis.Views.ScheduleView extends Backbone.View
  initialize: (attrs) ->
    @mainUrl = attrs.url
    @area_id = attrs.area
    @opens_at = attrs.opens_at
    @closes_at = attrs.closes_at

    @bindExternalEvents()

  url: ->
    @mainUrl || window.location.pathname + '/events'

  scheduler: ->
    @$el.data('kendoScheduler')

  bindExternalEvents: ->
    $ =>
      scheduler = @scheduler()
      setInterval ->
        if !scheduler._editor.container
          scheduler.dataSource.read()
        else
      , 30000

      $('a[data-toggle="tab"]').on 'shown.bs.tab', (e) =>
        scheduler.refresh()

      $('#area').on 'change', =>
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
    @$el.kendoScheduler
      culture: 'ru-RU'
      date: new Date()
      allDaySlot: false
      workDayStart: new Date(@opens_at)
      workDayEnd: new Date(@closes_at)
      min: new Date()
      showWorkHours: true
      editable:
        template: $("#eventFormTemplate").html()
      height: 700
      views: [
        "day",
        { type: "week", selected: true },
        "month"
      ]

      edit: (e) =>
        if (e.event.visual_type == 'disowned') || !gon.current_user
          alert 'Пожалуйста, сначала авторизуйтесь.'
          e.preventDefault()
      resize: (e) =>
        unless @validate(e.start, e.end, e.event) == true
          @scheduler().wrapper.find('.k-marquee-color').addClass 'invalid-slot'
        return
      resizeEnd: (e) =>
        validation = @validate(e.start, e.end, e.event)
        return if validation == true
        alert(validation)
        e.preventDefault()
        return
      move: (e) =>
        unless @validate(e.start, e.end, e.event) == true
          @scheduler().wrapper.find('.k-event-drag-hint').addClass 'invalid-slot'
        return
      moveEnd: (e) =>
        validation = @validate(e.start, e.end, e.event)
        return if validation == true
        alert(validation)
        e.preventDefault()
        return
      add: (e) =>
        validation = @validate(e.start, e.end, e.event)
        return if validation == true
        alert(validation)
        e.preventDefault()
        return
      save: (e) =>
        validation = @validate(e.start, e.end, e.event)
        if validation == true
          e.sender.dataSource.one 'requestEnd', -> $.get(window.location.pathname + '/total.js')
        else
          alert(validation)
          e.preventDefault()
        return
      schema:
        timezone: 'Europe/Moscow'
        model:
          id: 'id'
          fields:
            title:
              from: 'area_name'
              type: 'string'
            start:
              type: 'date'
              from: 'start'
            end:
              type: 'date'
              from: 'stop'
            recurrenceId:
              from: 'recurrence_id'
            recurrenceRule:
              from: 'recurrence_rule'
            recurrenceException:
              from: 'recurrence_exception'
            startTimezone:
              from: 'start_timezone'
            endTimezone:
              from: 'end_timezone'
            isAllDay:
              type: 'boolean'
              from: 'is_all_day'
      resources: [
        {
          field: 'visual_type'
          dataSource:[
            { text: 'Своё', value: 'owned', color: 'cadetblue', editable: false },
            { text: 'Чужое', value: 'disowned', color: '#ccc' },
            { text: 'Оплачено', value: 'paid', color: '#8ED869' },
            { text: 'Неоплаченный перенос', value: 'has_unpaid_changes', color: '#69D8D8' }
          ]
        },
        {
          field: 'coach_id'
          title: 'Тренер'
          multiple: false
          dataTextField: 'name'
          dataValueField: 'id'
          dataSource:
            transport:
              read:
                url: => window.location.pathname + "/coaches.json"
        },
        {
          field: 'stadium_service_ids'
          title: 'Доп. услуги'
          multiple: true
          dataTextField: 'name'
          dataValueField: 'id'
          dataSource:
            transport:
              read:
                url: => "/products/#{@area_id}.json"
        }
      ]
      dataSource:
        batch: false
        transport:
          read:
            dataType: 'json'
            url: (e, s) => @url() + '.json'
          update:
            dataType: 'json'
            url: (options) => "#{@url()}/#{options.id}"
            type: 'PUT'
          create:
            dataType: 'json'
            url: => @url()
            type: 'POST'
          destroy:
            dataType: 'json'
            url: (options) => "#{@url()}/#{options.id}"
            method: 'DELETE'
          parameterMap: (options, operation) =>
            if operation == 'read'
              return options
            if operation != 'read' && options
              return {event: options}
        schema:
          timezone: 'Europe/Moscow'
          model:
            id: 'id'
            fields:
              title:
                from: 'title'
                type: 'string'
                defaultValue: gon.current_user?.name
              start:
                type: 'date'
                from: 'start'
              end:
                type: 'date'
                from: 'stop'
              coach_id:
                from: 'coach_id'
                defaultValue: ''
              recurrenceId:
                from: 'recurrence_id'
              recurrenceRule:
                from: 'recurrence_rule'
              recurrenceException:
                from: 'recurrence_exception'
              startTimezone:
                from: 'start_timezone'
              stopTimezone:
                from: 'stop_timezone'
              isAllDay:
                type: 'boolean'
                from: 'is_all_day'

  validate: (start, stop, event) =>
    if @timeIsPast(event.start)
      return 'Невозможно сделать заказ на прошедшее время'
    else if @timeIsOccupied(start, stop, event)
      return 'Это время занято'
    else
      true

  timeIsPast: (start) =>
    if start < new Date() then true else false

  timeIsOccupied: (start, stop, event) =>
    occurences = @scheduler().occurrencesInRange(start, stop)
    idx = occurences.indexOf(event)
    occurences.splice(idx, 1) if idx > -1
    if occurences.length > 0 then true else false
