$ ->
  $('#user_terms_agree').change ->
    if $(this).is(':checked')
      $('.terms-required').removeClass('disabled')
    else
      $('.terms-required').addClass('disabled')

  $('#user_terms_agree').change()
