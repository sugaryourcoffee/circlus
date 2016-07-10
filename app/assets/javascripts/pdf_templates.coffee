jQuery ->
  $('form').on 'change', '.column-header', (event) ->
    parts = $(this).val().split('_')
    parts = ["title"] if parts.length == 1 and parts[0].length == 0
    content = ''
    for part in parts
      content += " #{part[0].toUpperCase()}#{part.slice(1)}"
    $(this).closest(".row").find(".column-name").val(content.slice(1))
    event.preventDefault()

