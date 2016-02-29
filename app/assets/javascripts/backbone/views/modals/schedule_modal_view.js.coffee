class Tennis.Views.ScheduleModalView extends Tennis.Views.ModalView
  form: JST['backbone/templates/schedule_form']

  events: ->
    _.extend({
      'submit form': 'submit',
      'change input': 'bindModel'
      'change select': 'bindModel'
      'change #repeatType': 'showRepeatForm'
      }, super)

  bindModel: (evt) ->
    changed = evt.currentTarget;
    value = $(evt.currentTarget).val();
    obj = {};
    obj[changed.name] = value;
    if changed.name == 'start' || changed.name == 'end'
      obj[changed.name] = moment.utc(value)

    @model.set('repeatType', @$('#repeatType').val())
    switch @$('#repeatType').val()
      when "weekly"
        _.each @$('[name=repeatWday]').serializeArray(), =>


    @model.set('')
    this.model.set(obj)

  initialize: (start, end) ->
    @model = new Tennis.Models.Event(start: start, end: end, repeats: new Tennis.Collections.Repeats())
    @listenTo(@model, 'change', @calculatePrice)

  variables: ->
    header: 'Бронирование'
    body: @form(start: @start().format('YYYY/MM/DD H:mm'), end: @end().format('YYYY/MM/DD H:mm'))

  start: ->
    @model.get('start')

  end: ->
    @model.get('end')

  submit: (e) =>
    e.preventDefault()
    # if @model.isOverlapping()
    window.grid.$el.fullCalendar('renderEvent', @model.eventObject(), true)
    window.grid.$el.fullCalendar('unselect')
    window.grid.collection.add(@model)

    @hide()

  afterRender: ->
    $('[data-datetimepicker]').datetimepicker
      lang: 'ru'
      step: 30
    $('[data-datepicker]').datetimepicker
      lang: 'ru'
    @calculatePrice()

  calculatePrice: ->
    $.get "/areas/#{window.grid.area}", (data) =>
      dur = Math.ceil(@model.get('end').diff(@model.get('start'), 'hours', true))
      total = data.price * dur
      time = moment.duration(dur, "hours").humanize()
      @$('[data-total]').html(time + ' = ' + total + ' руб.')

  showRepeatForm: (e) ->
    @$('[data-only]').addClass('hidden')
    if @$('#repeatType').find(':selected').val() == 'weekly'
      @$('[data-only=weekly]').removeClass('hidden')
