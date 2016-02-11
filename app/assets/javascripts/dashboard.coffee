Dropzone.autoDiscover = false
$ ->
  if $('.dropzone').length > 0
    myDropzone = new Dropzone '.dropzone',
      dictDefaultMessage: "Бросьте файлы прямо сюда, либо кликните."
      success: (resp) ->
        if resp.xhr.responseURL.match('.js')
          eval(resp.xhr.response)

  $('[data-blur-remote]').on 'blur', (e) ->
    $(this).parents('form').submit()

  $('.datatable').DataTable
    language:
      "processing": "Подождите...",
      "search": "Поиск:",
      "lengthMenu": "Показать _MENU_ записей",
      "info": "Записи с _START_ до _END_ из _TOTAL_ записей",
      "infoEmpty": "Записи с 0 до 0 из 0 записей",
      "infoFiltered": "(отфильтровано из _MAX_ записей)",
      "infoPostFix": "",
      "loadingRecords": "Загрузка записей...",
      "zeroRecords": "Записи отсутствуют.",
      "emptyTable": "В таблице отсутствуют данные",
      "paginate":
        "first": "Первая",
        "previous": "Предыдущая",
        "next": "Следующая",
        "last": "Последняя"
      "aria":
        "sortAscending": ": активировать для сортировки столбца по возрастанию",
        "sortDescending": ": активировать для сортировки столбца по убыванию"
