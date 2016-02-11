$ ->
  $('#coach_search').on 'submit', (e) ->
    $('.coaches').html('<i class="fa fa-refresh fa-spin"></i> Идет загрузка...')
