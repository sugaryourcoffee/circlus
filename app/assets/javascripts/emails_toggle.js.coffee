$(document).ready ->

  $('.emails_toggle').click (e) ->
    emails = $(this).closest('address').children('.emails').eq(0)

    if $(this).attr("title") == 'Show all emails'
      emails.show()
      $(this).attr('title', 'Hide emails')
    else
      emails.hide()
      $(this).attr('title', 'Show all emails')

    $(this).find('i').slideToggle(0)

    e.preventDefault()
