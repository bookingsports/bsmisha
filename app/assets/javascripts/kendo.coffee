#= require kendo.all
#= require kendo.timezones.min
#= require cultures/kendo.culture.ru-RU.min
#= require messages/kendo.messages.ru-RU.min
#= require_self

kendo.culture 'ru-RU'

grid = new Tennis.Views.ScheduleView
  el: '[data-grid]'
  court: gon.court_id
  opens_at: gon.opens_at
  closes_at: gon.closes_at
  url: gon.court_my_events_path

changes = new Tennis.Collections.Changes()
grid.render()
