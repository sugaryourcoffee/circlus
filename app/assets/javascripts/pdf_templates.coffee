$('form').on 'change', '.column-header', (event) ->
  parts = $(this).val().split('_')
  content = ''
  for part in parts
    content += " #{part[0].toUpperCase()}#{part.slice(1)}"
  $(this).siblings(".column-name").val(content.slice(1))
  event.preventDefault()

