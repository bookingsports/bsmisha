//= require fc/javascripts/fullcalendar.js
//= require fc/javascripts/fullcalendar/lang-all.js
//= require chosen.jquery.js
//= require_self
url = window.location.pathname + '/events';

/*kendo.culture('ru-RU');*/

canUpdate = true
isGrid = location.href.indexOf("grid") != -1
area_id = gon.area_id;
$(document).ready(function() {
    $('#calendar').fullCalendar({
        lang: 'ru',
        allDaySlot: false,
        defaultView: 'agendaWeek',
        header: {
            left: 'title',
            center: '',
            right: 'today prev next'
        },
        editable: true,
        axisFormat: 'HH:mm',
        droppable: true,
        minTime: gon.opens_at,
        maxTime: gon.closes_at,
        timezone: 'local',
        timeFormat: 'HH:mm',
        eventSources: [
            "/events.json?stadium=" + gon.stadium ,
            "/group_events.json?stadium=" + gon.stadium ,
        ],
        eventOverlap: false,
        eventDurationEditable: false,
        selectable: true,
        selectHelper: true,
        select: function(start, end, ev) {
            if (!gon.current_user)
            {
                alert('Пожалуйста, сначала авторизуйтесь.');
            }
            if ( start.isBefore(moment()) )
            {
                alert('Нельзя создать заказ на прошедшее время!');
                $('#calendar').fullCalendar('unselect');
            }
            else{
                $.getScript('/events/new?area_id='+ gon.area_id, function() {
                    $('#event_start').val(moment(start).format('DD.MM.YYYY HH:mm'));
                    $('#event_stop').val(moment(end).format('DD.MM.YYYY HH:mm'));
                    $('#group_event_start').val(moment(start).format('DD.MM.YYYY HH:mm'));
                    $('#group_event_stop').val(moment(end).format('DD.MM.YYYY HH:mm'));
                    $('.area_hidden').val(gon.area_id);
                });
            }
        },
        eventRender: function(event) {
            if (event.recurrence_rule) {

            }
        },
        eventClick: function(event, jsEvent, view) {

            if (!gon.current_user)
            {
                alert('Пожалуйста, сначала авторизуйтесь.');
            }
            if ( event.start.isBefore(moment()) )
            {
                alert('Занятие прошло!');
                $('#calendar').fullCalendar('unselect');
            }
            else {
                $.getScript(event.edit_url, function() {
                    $('.start_hidden').val(moment(event.start).format('YYYY-MM-DD HH:mm'));
                    $('.end_hidden').val(moment(event.end).format('YYYY-MM-DD HH:mm'));
                    $('#group_event_start').val(moment(event.start).format('DD.MM.YYYY HH:mm'));
                    $('#group_event_stop').val(moment(event.end).format('DD.MM.YYYY HH:mm'));
                });
            }

        },
        eventDrop: function (event, delta, revertFunc) {
                   }
    });
});

/*
$("#scheduler").kendoScheduler({
  culture: 'ru-RU',
  date: new Date(),
  allDaySlot: false,
  workDayStart: opens_at,
  workDayEnd: closes_at,
  showWorkHours: true,
  mobile: true,
  footer: false,
  editable:
  {
    template: $("#eventFormTemplate").html(),
    create: true,
    move: url.indexOf('grid') == -1,
    resize: url.indexOf('grid') == -1,
    update: url.indexOf('grid') == -1,
    editRecurringMode: "series"
  },
  height: 700,
  views: [
    { type: "day", showWorkHours: true},
  ],

  edit: function(e)
  {
    coach_id = e.container.find("#coach_id").kendoDropDownList({
      dataTextField: 'name',
      dataValueField: 'id',
      optionLabel: "Нет",
      valuePrimitive: true,
      dataSource:
      {
        transport:
        {
          read:
          {
            dataType: "json",
            url: "/grid/" + area_id + "/coaches.json"
          }
        },
        requestEnd: function (ee)
        {
          if (ee.response.length == 0 || gon.scope == "coach")
            e.container.find("#coach-wrapper").hide();
        }
      }
    }).data('kendoDropDownList');

    service_ids = e.container.find("#service_ids").kendoMultiSelect({
      dataTextField: 'name',
      dataValueField: 'id',
      valuePrimitive: true,
      dataSource:
      {
        transport:
        {
          read:
          {
            url: "/products/" + area_id + ".json"
          }
        },
        requestEnd: function (ee)
        {
          if (ee.response.length == 0)
            e.container.find("#services-wrapper").hide();
        }
      }
    })

    dropdown = e.container.find("[data-role=dropdownlist]").data("kendoDropDownList")
    dropdown.unbind("change", hide_never)
    dropdown.bind("change", hide_never)
    $(".k-recur-end-never").closest("li").hide()

    if (e.event.paid || !gon.current_user || gon.current_user.type == "StadiumUser")
    {
      e.container.find("#coach-wrapper").hide()
      e.container.find("#services-wrapper").hide()
    }

    if (e.event.isNew() && e.sender.viewName() == "month")
    {
      start = e.container.find("[name=start][data-role=datetimepicker]");
      end = e.container.find("[name=stop][data-role=datetimepicker]");
      date_start = new Date(e.event.start.getFullYear(), e.event.start.getMonth(), e.event.start.getDate(), opens_at.getHours(), opens_at.getMinutes(), opens_at.getSeconds())
      date_end = new Date(e.event.start.getFullYear(), e.event.start.getMonth(), e.event.start.getDate(), closes_at.getHours(), closes_at.getMinutes(), closes_at.getSeconds())

      $(start).data("kendoDateTimePicker").value(date_start);
      $(end).data("kendoDateTimePicker").value(date_end);
    }

    if (!e.event.isNew())
      e.container.find("#recurrence-wrapper").hide()

    if (!gon.current_user || (e.event.visual_type == 'disowned' && gon.current_user.type != "StadiumUser"))
    {
      alert('Пожалуйста, сначала авторизуйтесь.');
      e.preventDefault();
    }

    if (!gon.current_user
      || gon.current_user.type != "StadiumUser"
      || !gon.area_id
      || gon.current_user.areas.indexOf(gon.area_id) == -1)
    {
      e.container.find("#reason-wrapper").hide();
    }
  },
  resize: function (e)
  {
    if(validate(e.start, e.end, e.event) !== true)
    {
      this.wrapper.find('.k-marquee-color').addClass('invalid-slot')
      //e.preventDefault();
    }
  },
  resizeEnd: function (e)
  {
    validation = validate(e.start, e.end, e.event)
    if (validation !== true)
    {
      alert(validation)
      e.preventDefault()
    }
  },
  move: function (e)
  {
    if (validate(e.start, e.end, e.event) !== true)
      this.wrapper.find('.k-event-drag-hint').addClass('invalid-slot')
  },
  moveEnd: function (e)
  {
    validation = validate(e.start, e.end, e.event)
    e.sender.dataSource.one('requestEnd', function() { $.get(window.location.pathname + '/total.js'); });
    if (validation !== true)
    {
      alert(validation)
      e.preventDefault()
    }
  },
  add: function (e)
  {
    if (gon.current_user && gon.current_user.type == "Admin")
      e.preventDefault();
    else if (gon.current_user
      && gon.current_user.type == "StadiumUser"
      && gon.area_id
      && gon.current_user.areas.indexOf(gon.area_id) == -1)
      e.preventDefault();
    else if (gon.current_user && url.indexOf("grid") != -1 && gon.current_user.type != "StadiumUser")
      e.preventDefault();
    else
    {
      validation = validate(e.event.start, e.event.end, e.event)
      if (validation !== true && validation !== 'Заказ должен начинаться и заканчиваться в один день')
      {
        alert(validation);
        e.preventDefault();
      }
      else
      {
        if (gon.scope == "coach")
          e.event.coach_id = gon.coach_id;
      }
    }
  },
  save: function (e)
  {
    validation = validate(e.event.start, e.event.end, e.event)
    if (validation === true)
    {
      setTimeout(function() { e.sender.dataSource.read();}, 500);
      e.sender.dataSource.one('requestEnd', function () { $.get(window.location.pathname + '/total.js'); });
      if (e.event.visual_type == 'paid')
        e.event.visual_type = 'has_unpaid_changes'
    }
    else
    {
      alert(validation);
      e.preventDefault();
    }
  },
  remove: function (e)
  {
    if (e.event.visual_type == "owned"
      || (gon.current_user
        && gon.current_user.type == "StadiumUser"
        && gon.current_user.areas.indexOf(gon.area_id) != -1))
      e.sender.dataSource.one('requestEnd', function () { $.get(window.location.pathname + '/total.js'); });
    else
    {
      alert("Нельзя удалить заказ.")
      e.preventDefault();
    }
  },
  schema:
  {
    timezone: 'Europe/Moscow',
    model:
    {
      id: 'id',
      fields:
      {
        title:
        {
          from: 'area_name',
          type: 'string'
        },
        start:
        {
          type: 'date',
          from: 'start'
        },
        end:
        {
          type: 'date',
          from: 'stop'
        },
        recurrenceId:
        {
          from: 'recurrence_id'
        },
        recurrenceRule:
        {
          from: 'recurrence_rule'
        },
        recurrenceException:
        {
          from: 'recurrence_exception'
        },
        startTimezone:
        {
          from: 'start_timezone'
        },
        endTimezone:
        {
          from: 'end_timezone'
        },
        isAllDay:
        {
          type: 'boolean',
          from: 'is_all_day'
        },
        reason:
        {
          from: 'reason'
        }
      }
    }
  },
  resources: [
    {
      field: 'visual_type',
      dataSource:[
        { text: 'Своё', value: 'owned', color: 'cadetblue', editable: false },
        { text: 'Чужое', value: 'disowned', color: '#ccc' },
        { text: 'Оплачено', value: 'paid', color: '#8ED869' },
        { text: 'Забронировано', value: 'confirmed', color: '#2f4f4f' },
        { text: 'Заблокировано', value: 'locked', color: '#000' },
        { text: 'Неоплаченный перенос', value: 'has_unpaid_changes', color: '#69D8D8' },
        { text: 'Оплаченный перенос', value: 'has_paid_changes', color: '#3234c2' },
        { text: 'Выставлено на продажу', value: 'for_sale', color: '#ffe135' }
      ]
    }
  ],
  dataSource:
  {
    batch: false,
    transport:
    {
      read:
      {
        dataType: 'json',
        url: url + '.json'
      },
      update:
      {
        dataType: 'json',
        url: function (options) {return url + "/" + options.id},
        type: 'PUT'
      },
      create:
      {
        dataType: 'json',
        url:  url,
        type: 'POST'
      },
      destroy:
      {
        dataType: 'json',
        url: function (options) {return url + "/" + options.id; },
        method: 'DELETE'
      },
      parameterMap: function (options, operation){
        if (operation == 'read')
          return options
        if (operation != 'read' && options)
          return {event: options}
      }
    },
    schema:
    {
      timezone: 'Europe/Moscow',
      errors: "error",
      model:
      {
        id: 'id',
        fields:
        {
          title:
          {
            from: 'title',
            type: 'string',
            defaultValue: (gon.current_user ? gon.current_user.name : "")
          },
          start:
          {
            type: 'date',
            from: 'start'
          },
          end:
          {
            type: 'date',
            from: 'stop'
          },
          coach_id:
          {
            from: 'coach_id',
            defaultValue: ''
          },
          service_ids:
          {
            from: 'service_ids'
          },
          recurrenceId:
          {
            from: 'recurrence_id'
          },
          recurrenceRule:
          {
            from: 'recurrence_rule'
          },
          recurrenceException:
          {
            from: 'recurrence_exception'
          },
          startTimezone:
          {
            from: 'start_timezone'
          },
          stopTimezone:
          {
            from: 'stop_timezone'
          },
          isAllDay:
          {
            type: 'boolean',
            from: 'is_all_day'
          },
          paid:
          {
            type: 'boolean',
            from: 'paid'
          },
          paidTransfer:
          {
            type: 'boolean',
            from: 'paid_transfer'
          },
          reason:
          {
            from: 'reason'
          }
        }
      }
    }
  }
});

function validate (start, stop, event)
{
  var returnString = [];
  if (!gon.current_user)
    returnString.push("Пожалуйста, авторизуйтесь или зарегистрируйтесь");
  if (event.visual_type == 'disowned')
    returnString.push('Нельзя изменить заказ чужого пользователя');
  if (event.visual_type == 'for_sale')
    returnString.push('Нельзя изменить заказ, выставленный на продажу');
  if (event.visual_type == "confirmed")
    returnString.push('Нельзя изменить забронированный заказ');
  if (event.paid && event.paidTransfer)
    returnString.push('Нельзя изменить оплаченный и перенесенный заказ');
  if (timeIsPast(start, event))
    returnString.push('Невозможно сделать заказ на прошедшее время');
  if (timeIsOccupied(start, stop, event))
    returnString.push('Это время занято');
  if (eventLongerThanOneDay(start, stop, event))
    returnString.push('Заказ должен начинаться и заканчиваться в один день');
  if (hasSpanOfHalfAnHour(start, stop, event))
    returnString.push('Окна между заказами должны быть длиной в час или более');
  return (returnString.join(", ") || true);
}

function timeIsPast (start, event)
{
  if (start < new Date() || event.start < new Date())
    return true;
  else
    return false;
}

function timeIsOccupied (start, stop, event)
{
  scheduler = $("#scheduler").getKendoScheduler();
  occurences = scheduler.occurrencesInRange(start, stop);
  idx = occurences.indexOf(event);
  if(idx > -1)
    occurences.splice(idx, 1);
  return occurences.length > 0;
}

function eventLongerThanOneDay (start, stop)
{
  if ((start == undefined || stop == undefined)
    || (start.getFullYear() == stop.getFullYear()
      && start.getMonth() == stop.getMonth()
      && start.getDate() == stop.getDate()))
    return false;
  else
    return true;
}

function hasSpanOfHalfAnHour (start, stop, event)
{
  if (gon.currentUser && gon.current_user.type == "StadiumUser")
    return false;
  occurencesBefore1 = scheduler.occurrencesInRange(new Date(start.getTime() - 1000 * 60 * 30), start)
  occurencesBefore2 = scheduler.occurrencesInRange(new Date(start.getTime() - 1000 * 60 * 60), new Date(start.getTime() - 1000 * 60 * 30))
  occurencesAfter1 = scheduler.occurrencesInRange(stop, new Date(stop.getTime() + 1000 * 60 * 30))
  occurencesAfter2 = scheduler.occurrencesInRange(new Date(stop.getTime() + 1000 * 60 * 30), new Date(stop.getTime() + 1000 * 60 * 60))

  idx = occurencesBefore1.indexOf(event); if(idx > -1) occurencesBefore1.splice(idx, 1);
  idx = occurencesBefore2.indexOf(event); if(idx > -1) occurencesBefore2.splice(idx, 1);
  idx = occurencesAfter1.indexOf(event); if(idx > -1) occurencesAfter1.splice(idx, 1);
  idx = occurencesAfter2.indexOf(event); if(idx > -1) occurencesAfter2.splice(idx, 1);

  if (occurencesBefore1.length - occurencesBefore2.length >= 0
      && occurencesAfter1.length - occurencesAfter2.length >= 0)
    return false;
  else
    return true;
}

function hide_never ()
{
  $(".k-recur-end-never").closest("li").hide();
  $(".k-recur-end-count").click();
}
*/

/*
scheduler = $("#scheduler").getKendoScheduler();

setInterval(updateData, 30000)

$("#scheduler").mousedown(function() {  canUpdate = false; });
$("#scheduler").mouseup(function() { canUpdate = true; });
$("#scheduler").mouseleave(function() { canUpdate = true; });


scheduler.dataSource.bind("error", function(e)
{
  if (e.errors)
  {
    alert(e.errors);
    scheduler.one("dataBinding", function (e)
    {
      //prevent saving if server error is thrown
      e.preventDefault();
    });
  }
});

$('a[data-toggle="tab"]').on('shown.bs.tab', function (e) {
  scheduler.refresh();
});

$('#area').on('change', function() {
  scheduler.dataSource.read();
});

function updateData()
{
  if (!scheduler._editor.container && canUpdate)
  {
    scheduler.dataSource.read()
    if (!isGrid)
      scheduler.dataSource.one('requestEnd', function() { $.get(window.location.pathname + '/total.js'); });
  }
}

updateData();

$("#scheduler").on("click", ".k-scheduler-table td, .k-event", function(e)
{
  e.stopPropagation();
  target = $(e.currentTarget);
  if (target.hasClass("k-event"))
  {
    event = scheduler.occurrenceByUid(target.data("uid"));
    scheduler.editEvent(event);
  }
  else
  {
    slot = scheduler.slotByElement(target[0]);
    scheduler.addEvent({ start: slot.startDate, end: slot.endDate });
  }
})
*/
