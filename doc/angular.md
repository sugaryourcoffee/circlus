# Dynamic UI with JavaScript (and Angular)
Circlus is supposed to provide reasonable user experience by being dynamic.
Angular provides a good way to bring dynamics to a user interface. Here we 
describe several use cases we implement into Circlus.

# Toggle additional information
A member has a main phone number and main email address. But a member can also
have additional phones and email addresses. Standard wise we only show the main
values. If the user wants to view the additional values he can view these by
pressing a toggle button.

The general approach is to enclose the content in a `section` and provide the
Angular script that is used within the `section`.

    <section ng-app="phones" ng-model="showPhones" ng-init="showPhones = false">
      <button ng-click="showPhones = !showPhones">Show/Hide</button>
      <ul ng-if="showPhones">
        Here go the phones
      </ul>
    </section>

    <script>
      var app = angular.module("phones", []);
    </script>

If I use this code in an index view only the first entry is toggling the
content all others don't react on the toggle button.

The same solution with UJS. First the view code

    <% if member.phones.any? %>
      <%= link_to '#phones', 
                  { class: "phones_toggle", title: "Show all phones" } do %>
        <i class="glyphicon glyphicon-menu-down" style="display: inline"></i>
        <i class="glyphicon glyphicon-menu-up"   style="display: none"></i>
      <% end %>
      </br>
      <div class="phones" style="display: none">
        <% member.phones.each do |phone| %>
          <small><%= if_mobile phone.number, true, phone.category %></small>
        <% end %>
      </div>
    <% else %>
      </br>
    <% end %>

The helper `if_mobile` is in `app/helpers/application_helper.rb` and the 
`glyphicon` is from Boostrap.

The JavaScript code gets invoked when the link with the class `phones_toggle' is
clicked.

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

