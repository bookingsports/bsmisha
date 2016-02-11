class Tennis.Views.CheckoutView extends Backbone.View
  events: {}

  initialize: ->
    $ =>
      @refreshPrice()
      $('#court').on 'change', =>
        @refreshPrice()


  refreshPrice: ->
    $.get("/courts/#{$('#court').find(":selected").val()}.json")
      .done (data, e) =>
        if $('[data-coach-price]').length
          price = parseInt(data.price) + parseInt($('[data-coach-price]').data('coachPrice'))
        else
          price = data.price

        @$('[data-court-price]').html("#{price} руб.")
