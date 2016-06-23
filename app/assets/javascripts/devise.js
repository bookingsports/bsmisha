//= require masked_input

$(".form-phone").mask("+7 (999) 999-99-99");

$('.terms_agree_checkbox').change(function() {
  if ($(this).is(':checked'))
    $('.terms-required').removeClass('disabled')
  else
    $('.terms-required').addClass('disabled')
})
$('.terms_agree_checkbox').change()

$('#user_type_selector').change(function() {
  $('.form_container').css('display', 'none')
  switch($('#user_type_selector').val())
  {
    case 'Customer':
    $('#customer_form').css('display', 'block');
    break;
    case 'CoachUser':
    $('#coach_form').css('display', 'block');
    break;
    case 'StadiumUser':
    $('#stadium_form').css('display', 'block');
    break;
  }
})
$('#user_type_selector').change()