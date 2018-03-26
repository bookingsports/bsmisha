$ ->
  $('#stadium_search').on 'submit', (e) ->
    $('.stadiums').html('<i class="fa fa-refresh fa-spin"></i> Идет загрузка...')