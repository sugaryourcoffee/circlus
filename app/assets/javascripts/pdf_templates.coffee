jQuery ->
  $('form').on 'change', '.column-header', (event) ->
    parts = $(this).val().split('_')
    parts = ["title"] if parts.length == 1 and parts[0].length == 0
    content = ''
    for part in parts
      content += " #{part[0].toUpperCase()}#{part.slice(1)}"
    $(this).closest(".row").find(".column-name").val(content.slice(1))
    event.preventDefault()
  
  $('.column-class').parent().hide()
  collections = $('.column-class').html()
  $('form').on 'change', '.associated-class', (event) ->
    console.log(collections)
    clazz = $('.associated-class :selected').text()
    console.log(clazz)
    options = $(collections).filter("optgroup[label='#{clazz}']").html()
    console.log(options)
    if options
      $('.column-class').html(options)
      $('.column-class').parent().show()
    else
      $('.column-class').empty()
      $('.column-class').parent().hide()
    event.preventDefault()

