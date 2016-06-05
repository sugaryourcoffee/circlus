$(document).ready ->

  $('.phones_toggle').click (e) ->
    phones = $(this).closest('address').children('.phones').eq(0)

    if $(this).attr("title") == 'Show all phones'
      phones.show()
      $(this).attr('title', 'Hide phones')
    else
      phones.hide()
      $(this).attr('title', 'Show all phones')

    $(this).find('i').slideToggle(0)

    e.preventDefault()
