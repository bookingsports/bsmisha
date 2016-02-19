$ =>
  (new Tennis.Views.ScheduleView
    el: '#scheduler'
    court: gon.court_id
    opens_at: gon.opens_at
    closes_at: gon.closes_at
  ).render()
