//= require masked_input

$(".form-phone").mask("+7 (999) 999-99-99");

$('.terms_agree_checkbox').change(function() {
  if ($(this).is(':checked'))
      $(this).parents('form').find('.terms-required').removeAttr('disabled');
  else
      $(this).parents('form').find('.terms-required').attr('disabled', 'disabled');
});

$(window).load(function() {
    $('.terms_agree_checkbox').attr("checked", false);
});

$('#user_type_selector').change(function() {
  $('.form_container').css('display', 'none');
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
});
$('#user_type_selector').change();


// выбор всех елементов таблицы по общему чекбоксу

$(".check_all").change(function () {

    var checkBoxes = $(this).parents('table').find('.check-box');

    checkBoxes.prop('checked', $(this).prop("checked"));

});

// сброс общего чекбокса, если чекнул хоть один из элементов

$(".check-box").change(function(){

    if ($(this).parents('table').length) {
        var checkAll = $(this).parents('table').find('.check_all');

        if (!$(this).prop('checked')) {
            checkAll.prop('checked', false);
        }
    }

});

if (!(/android|iphone|ipod|ipad|series60|symbian|windows ce|blackberry/i.test(navigator.userAgent))) {
    $('.j-site-table__item-option_mobile').hide();
} else {
    $('.j-site-table__item-option_desctop').hide();
}

$('.schedule-legend-nav__dop-button').click(function(e){
    e.preventDefault();

    $('.schedule-legend-nav__dop-wrap').toggleClass('open');
});

setTimeout(function () {
  $('.alert').remove();
}, 10000);