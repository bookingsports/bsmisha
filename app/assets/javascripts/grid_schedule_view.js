//= require fc/javascripts/fullcalendar.js
//= require fc/javascripts/fullcalendar/lang-all.js
//= require chosen.jquery.js
//= require_self

url = window.location.pathname + '/events';
area_id = gon.area_id;
opens_at = "8:00";
closes_at = "24:00"
console.log(gon.opens_at);
console.log(gon.closes_at);

/*kendo.culture('ru-RU');*/

canUpdate = true
isGrid = location.href.indexOf("grid") != -1

$(document).ready(function() {
    var date = new Date();
    var d = date.getDate();
    var m = date.getMonth();
    var y = date.getFullYear();

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
        minTime: opens_at,
        maxTime: closes_at,
        timezone: 'local',
        timeFormat: 'HH:mm',
        events: url + ".json",
        eventOverlap: false,
        eventDurationEditable: false,
        selectable: true,
        selectHelper: true,
        eventRender: function(event) {
            console.log(event);
            if (event.recurrence_rule) {
                console.log(event.recurrence_rule);

            }
        },
        eventClick: function(event, jsEvent, view) {

            if (!gon.current_user)
            {
                alert('Пожалуйста, сначала авторизуйтесь.');
            }
            else {
                $.getScript(event.edit_url, function() {
                    $('.start_hidden').val(moment(event.start).format('YYYY-MM-DD HH:mm'));
                    $('.end_hidden').val(moment(event.end).format('YYYY-MM-DD HH:mm'));

                });
            }

        },
        eventDrop: function (event, delta, revertFunc) {
            console.log(event);
        }
    });
});

/*$("#scheduler").kendoScheduler({
    date: new Date(),
    allDaySlot: false,
    startTime: new Date('2013/6/13 07:00 AM'),
    height: 700,
    mobile: true,
    workDayStart: opens_at,
    workDayEnd: closes_at,
    views: [
        { type: "day", showWorkHours: true},
        { type: "week", selected: true, showWorkHours: true },
        "month"
    ],
    footer: false,
    editable:
    {
        create: false,
        move: false,
        resize: false,
        update: false,
        destroy: false
    },
    schema: {
        model: {
            id: "id",
            fields: {
                stop: {
                    type: 'date',
                    from: 'end'
                },
                start: {
                    type: 'date',
                    from: 'start'
                },
                end: {
                    type: 'date',
                    from: 'stop'
                },
                recurrenceId: {
                    from: 'recurrence_id'
                },
                recurrenceRule: {
                    from: 'recurrence_rule'
                },
                recurrenceException: {
                    from: 'recurrence_exception'
                },
                startTimezone: {
                    from: 'start_timezone'
                },
                endTimezone: {
                    from: 'end_timezone'
                },
                isAllDay: {
                    type: 'boolean',
                    from: 'is_all_day'
                }
            }
        }
    },
    edit: function (e) {
        if ((e.event.visual_type == 'disowned') || !gon.current_user) {
            alert('Пожалуйста, сначала авторизуйтесь.');
            e.preventDefault();
        }
    },
    resize: function (e) {
        if (timeIsOccupied(e.start, e.end, e.event)) {
            this.wrapper.find('.k-marquee-color').addClass('invalid-slot');
            e.preventDefault();
        }
    },
    resizeEnd: function (e) {
        if (timeIsOccupied(e.start, e.end, e.event)) {
            alert('Это время занято');
            e.preventDefault();
        }
    },
    move: function (e) {
        if (timeIsOccupied(e.start, e.end, e.event))
            this.wrapper.find('.k-event-drag-hint').addClass('invalid-slot');
    },
    moveEnd: function (e) {
        if (timeIsOccupied(e.start, e.end, e.event)) {
            alert('Это время занято');
            e.preventDefault();
        }
    },
    save: function (e) {
        if (timeIsOccupied(e.event.start, e.event.stop, e.event)) {
            alert('Это время занято');
            e.preventDefault();
        }
        else
            e.sender.dataSource.one('requestEnd', function () {
                $.get(window.location.pathname + '/total.js');
            });
    },
    resources: [
        {
            field: 'kendo_area_id',
            dataSource: [
                {text: '0', value: '0', color: '#3499DB'},
                {text: '1', value: '1', color: '#467FA4'},
                {text: '2', value: '2', color: '#115D8E'},
                {text: '3', value: '3', color: '#65B8ED'},
                {text: '4', value: '4', color: '#8AC6ED'},
                {text: '5', value: '5', color: '#454CE1'},
                {text: '6', value: '6', color: '#5155A8'},
                {text: '7', value: '7', color: '#161C92'},
                {text: '8', value: '8', color: '#7379F0'},
                {text: '9', value: '9', color: '#9499F0'},
                {text: '10', value: '10', color: '#42A977'},
                {text: '11', value: '11', color: '#0E9252'},
                {text: '12', value: '12', color: '#5E4BD8'},
                {text: '13', value: '13', color: '#3A2E85'},
                {text: '14', value: '14', color: '#4380D3'},
                {text: '15', value: '15', color: '#FF0000'},
                {text: '16', value: '16', color: '#BF3030'},
                {text: '17', value: '17', color: '#A60000'},
                {text: '18', value: '18', color: '#FF4040'},
                {text: '19', value: '19', color: '#FF7400'},
                {text: '20', value: '20', color: '#A64B00'},
                {text: '21', value: '21', color: '#009999'},
                {text: '22', value: '22', color: '#006363'},
                {text: '23', value: '23', color: '#269926'},
                {text: '24', value: '24', color: '#008500'},
                {text: '25', value: '25', color: '#B90091'},
                {text: '26', value: '26', color: '#79005E'},
                {text: '27', value: '27', color: '#799E00'},
                {text: '28', value: '28', color: '#033E6B'},
                {text: '29', value: '29', color: '#9C1754'}
            ]
        }
    ],
    dataSource: {
        batch: false,
        transport: {
            read: {
                dataType: 'json',
                url: url + '.json'
            },
            update: {
                dataType: 'json',
                url: function (options) {
                    return url + "/" + options.id;
                },
                type: 'PUT'
            },
            create: {
                dataType: 'json',
                url: url,
                type: 'POST',
            },
            destroy: {
                dataType: 'json',
                url: function (options) {
                    return url + "/" + options.id;
                },
                method: 'DELETE'
            },
            parameterMap: function (options, operation) {
                if (operation == 'read')
                    return options
                if (operation != 'read' && options)
                    return {event: options}
            }
        },
        schema: {
            timezone: 'Europe/Moscow',
            model: {
                id: 'id',
                fields: {
                    title: {
                        from: 'area_name_with_stadium',
                        type: 'string'
                    },
                    start: {
                        type: 'date',
                        from: 'start'
                    },
                    end: {
                        type: 'date',
                        from: 'stop'
                    },
                    recurrenceId: {
                        from: 'recurrence_id'
                    },
                    recurrenceRule: {
                        from: 'recurrence_rule'
                    },
                    recurrenceException: {
                        from: 'recurrence_exception'
                    },
                    startTimezone: {
                        from: 'start_timezone'
                    },
                    endTimezone: {
                        from: 'end_timezone'
                    },
                    isAllDay: {
                        type: 'boolean',
                        from: 'is_all_day'
                    }
                }
            }
        }
    }
});

scheduler = $("#scheduler").getKendoScheduler()

setInterval(function () {
    if (!scheduler._editor.container)
        scheduler.dataSource.read();
}, 30000)

$('a[data-toggle="tab"]').on('shown.bs.tab', function (e) {
    scheduler.refresh()
});

$('#area').on('change', function () {
    scheduler.dataSource.read()
    scheduler.resources[1].dataSource.read()
});

function timeIsOccupied(start, stop, event) {
    occurences = scheduler.occurrencesInRange(start, stop);
    idx = occurences.indexOf(event);
    if (idx > -1)
        occurences.splice(idx, 1);
    return occurences.length > 0;
}
*/