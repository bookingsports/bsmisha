class Tennis.Views.CheckoutView extends Backbone.View
  events: {}

  initialize: ->
    $ =>
      @refreshPrice()
      $('#area').on 'change', =>
        @refreshPrice()


  refreshPrice: ->
    $.get("/areas/#{$('#area').find(":selected").val()}.json")
      .done (data, e) =>
        if $('[data-coach-price]').length
          price = parseInt(data.price) + parseInt($('[data-coach-price]').data('coachPrice'))
        else
          price = data.price

        @$('[data-area-price]').html("#{price} руб.")
