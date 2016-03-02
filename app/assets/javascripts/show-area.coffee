$ =>
  (new Tennis.Views.ScheduleView
    el: '#scheduler'
    area: gon.area_id
    opens_at: gon.opens_at
    closes_at: gon.closes_at
  ).render()
