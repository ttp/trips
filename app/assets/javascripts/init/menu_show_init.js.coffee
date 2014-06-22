$ ->
  $('#users_count').click ->
    $this = $(this)
    $this.hide()

    form = $('#form_users_count')
    form.find('input.form-control').val($this.text())
    form.removeClass 'hidden'
    false
  $('#form_users_count .editable-cancel').click ->
    $('#form_users_count').addClass('hidden')
    $('#users_count').show()
