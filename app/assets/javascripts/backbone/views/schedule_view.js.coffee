class Tennis.Views.ScheduleView extends Backbone.View
  initialize: (attrs) ->
    @mainUrl = attrs.url
    @area_id = attrs.area
    @opens_at = new Date(attrs.opens_at)
    @closes_at = new Date(attrs.closes_at)

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
          scheduler.dataSource.one 'requestEnd', -> $.get(window.location.pathname + '/total.js')
        else
      , 30000

      $('a[data-toggle="tab"]').on 'shown.bs.tab', (e) =>
        scheduler.refresh()

      $('#area').on 'change', =>
        scheduler.dataSource.read()

      scheduler.dataSource.read()
      scheduler.dataSource.one 'requestEnd', -> $.get(window.location.pathname + '/total.js')

      $("#scheduler").on("click", ".k-scheduler-table td, .k-event", (e) =>
        e.stopPropagation();
        target = $(e.currentTarget);
        ee=e;
        if (@url().indexOf('grid') != -1)
          return
        else if (target.hasClass("k-event"))
          event = scheduler.occurrenceByUid(target.data("uid"));
          scheduler.editEvent(event);
        else
          slot = scheduler.slotByElement(target[0]);
          scheduler.addEvent({ start: slot.startDate, end: slot.endDate });
      )

  render: ->
    @$el.kendoScheduler
      culture: 'ru-RU'
      date: new Date()
      allDaySlot: false
      workDayStart: @opens_at
      workDayEnd: @closes_at
      min: new Date()
      showWorkHours: true
      mobile: true
      editable:
        template: $("#eventFormTemplate").html()
        create: @url().indexOf('grid') == -1
        move: @url().indexOf('grid') == -1
        resize: @url().indexOf('grid') == -1
        update: @url().indexOf('grid') == -1
        editRecurringMode: "series"
      height: 700
      views: [
        "day",
        { type: "week", selected: true },
        "month"
      ]

      edit: (e) =>
        coach_id = e.container.find("#coach_id").kendoDropDownList({
          dataTextField: 'name',
          dataValueField: 'id',
          optionLabel: "Нет",
          valuePrimitive: true,
          dataSource:
            transport:
              read:
                dataType: "json",
                url: => "/grid/#{@area_id}/coaches.json"
            requestEnd: (ee) =>
              if ee.response.length == 0
                e.container.find("#coach-wrapper").hide();
        }).data('kendoDropDownList');

        stadium_service_ids = e.container.find("#stadium_service_ids").kendoMultiSelect({
          dataTextField: 'name',
          dataValueField: 'id',
          valuePrimitive: true,
          dataSource:
            transport:
              read:
                url: => "/products/#{@area_id}.json"
            requestEnd: (ee) =>
              if ee.response.length == 0
                e.container.find("#services-wrapper").hide();
        })

        dropdown = e.container.find("[data-role=dropdownlist]").data("kendoDropDownList")
        dropdown.unbind("change", @hide_never)
        dropdown.bind("change", @hide_never)
        $(".k-recur-end-never").closest("li").hide()

        if e.event.paid
          e.container.find("#coach-wrapper").hide()
          e.container.find("#services-wrapper").hide()

        if e.event.isNew && e.sender.viewName() == "month"
          start = e.container.find("[name=start][data-role=datetimepicker]");
          end = e.container.find("[name=stop][data-role=datetimepicker]");
          date_start = new Date(e.event.start.getFullYear(), e.event.start.getMonth(), e.event.start.getDate(), @opens_at.getHours(), @opens_at.getMinutes(), @opens_at.getSeconds())
          date_end = new Date(e.event.start.getFullYear(), e.event.start.getMonth(), e.event.start.getDate(), @closes_at.getHours(), @closes_at.getMinutes(), @opens_at.getSeconds())

          $(start).data("kendoDateTimePicker").value(date_start);
          $(end).data("kendoDateTimePicker").value(date_end);


        if !gon.current_user || (e.event.visual_type == 'disowned' && gon.current_user.type != "StadiumUser")
          alert 'Пожалуйста, сначала авторизуйтесь.'
          e.preventDefault()
      resize: (e) =>
        unless @validate(e.start, e.end, e.event) == true
          @scheduler().wrapper.find('.k-marquee-color').addClass 'invalid-slot'
          e.preventDefault();
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
        e.sender.dataSource.one 'requestEnd', -> $.get(window.location.pathname + '/total.js')
        return if validation == true
        alert(validation)
        e.preventDefault()
        return
      add: (e) =>
        if gon.current_user && (gon.current_user.type == "CoachUser" || gon.current_user.type == "Admin")
          e.preventDefault()
          return
        else
          validation = @validate(e.start, e.end, e.event)
          return if validation == true
          alert(validation)
          e.preventDefault()
          return
      save: (e) =>
        validation = @validate(e.start, e.end, e.event)
        if validation == true
          e.sender.dataSource.one 'requestEnd', -> $.get(window.location.pathname + '/total.js')
          if e.event.visual_type == 'paid'
            e.event.visual_type = 'has_unpaid_changes'
        else
          alert(validation)
          e.preventDefault()
        return
      remove: (e) =>
        if e.event.visual_type == "owned" || (gon.current_user && gon.current_user.type == "StadiumUser" && gon.current_user.areas.indexOf(gon.area_id) != -1)
          e.sender.dataSource.one 'requestEnd', -> $.get(window.location.pathname + '/total.js')
        else
          alert("Нельзя удалить заказ.")
          e.preventDefault();
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
            { text: 'Забронировано', value: 'confirmed', color: '#2f4f4f' },
            { text: 'Заблокировано', value: 'locked', color: '#000' },
            { text: 'Неоплаченный перенос', value: 'has_unpaid_changes', color: '#69D8D8' }
            { text: 'Оплаченный перенос', value: 'has_paid_changes', color: '#3234c2' }
            { text: 'Выставлено на продажу', value: 'for_sale', color: '#ffe135' }
          ]
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
              stadium_service_ids:
                from: 'stadium_service_ids'
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
              paid:
                type: 'boolean'
                from: 'paid'
              paidTransfer:
                type: 'boolean'
                from: 'paid_transfer'

  validate: (start, stop, event) =>
    if !gon.current_user
      return "Пожалуйста, авторизуйтесь или зарегистрируйтесь"
    else if event.visual_type == 'disowned'
      return 'Нельзя изменить заказ чужого пользователя'
    else if event.visual_type == "confirmed"
      return 'Нельзя изменить забронированный заказ'
    else if event.paid && event.paidTransfer
      return 'Нельзя изменить оплаченный и перенесенный заказ'
    else if @timeIsPast(event.start)
      return 'Невозможно сделать заказ на прошедшее время'
    else if @timeIsOccupied(event.start, event.end, event)
      return 'Это время занято'
    else if @eventLongerThanOneDay(event.start, event.end, event)
      return 'Заказ должен начинаться и заканчиваться в один день'
    else if @hasSpanOfHalfAnHour(event.start, event.end)
      return 'Окна между заказами должны быть длиной в час или более'
    else
      true

  timeIsPast: (start) =>
    if start < new Date() then true else false

  timeIsOccupied: (start, stop, event) =>
    occurences = @scheduler().occurrencesInRange(start, stop)
    idx = occurences.indexOf(event)
    occurences.splice(idx, 1) if idx > -1
    if occurences.length > 0 then true else false

  eventLongerThanOneDay: (start, stop) =>
    if (start == undefined || stop == undefined) || (start.getFullYear() == stop.getFullYear() && start.getMonth() == stop.getMonth() && start.getDate() == stop.getDate()) then false else true

  hasSpanOfHalfAnHour: (start, stop) =>
    if gon.current_user.type == "StadiumUser"
      return false
    occurencesBefore1 = @scheduler().occurrencesInRange(new Date(start.getTime() - 1000 * 60 * 30), start).length
    occurencesBefore2 = @scheduler().occurrencesInRange(new Date(start.getTime() - 1000 * 60 * 60), new Date(start.getTime() - 1000 * 60 * 30)).length
    occurencesAfter1 = @scheduler().occurrencesInRange(stop, new Date(stop.getTime() + 1000 * 60 * 30)).length
    occurencesAfter2 = @scheduler().occurrencesInRange(new Date(stop.getTime() + 1000 * 60 * 30), new Date(stop.getTime() + 1000 * 60 * 60)).length
    if occurencesBefore1 - occurencesBefore2 >= 0 && occurencesAfter1 - occurencesAfter2 >= 0 then false else true

  hide_never: () =>
    $(".k-recur-end-never").closest("li").hide()
    $(".k-recur-end-count").click()
