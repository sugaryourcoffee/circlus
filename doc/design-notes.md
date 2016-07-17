# Circlus
Circlus (Latin for group, convention, organization) is a web application to 
organize groups, members and events. Circlus provides following functions

* Add a Group
* Add an organization, where a organization is for example a family
* Add Members to a organization and to Groups
* Create Events associated to a Group
* Assign Members to an Event. Members can also register for an Event
* Show events in an events calendar
* Print reports for Events, and the participants
* Print contact lists
* Reports may be configurable in fields to print

# Models
The Circlus application consists of following objects

Object       | Description                        | Association
------------ | ---------------------------------- | ---------------------------
User         | user of the application            | Member, Organization
Member       | a person that may be a User        | Organization, Group, Event, User
Organization | has an address and a name          | Member, Organization
Group        | organization that organizes events | Member, Event
Event        | event organized by a group         | Group, Participant (Member)

## Member
A Member belongs to an organization and may belong to a group and may be a user.

Field           | Description
--------------- | ----------------------
title           | 
name            | through: :organization
first\_name     | 
date\_of\_birth |
phone           |
email           |
information     |

Associations | belongs\_to  | has\_many                    | many\_to\_many
------------ | ------------ | ---------------------------- | --------------
Phone        |              | phones                       |
Email        |              | emails                       |
Organization | organization |                              |
Group        |              |                              | groups 
Event        |              | events through registrations | 

## Organization
A organization may have many members.

Field       | Description
----------- | -----------
name        |
street      |
zip         |
town        |
country     |
phone       |
email       |
website     |
information |

Associations | belongs\_to | has\_many | many\_to\_many
------------ | ----------- | --------- | --------------
Member       |             | members   |
User         | user        |           |

## Group
A group is organizing events.

Field       | Description
----------- | -----------
name        |
description |
website     |

Associations | belongs\_to | has\_many | many\_to\_many
------------ | ----------- | --------- | --------------
User         | user        |           |
Member       |             |           | members   
Event        |             | events    |

## Event
An event is organized by a group.

Field              | Description
------------------ | -----------
title              |
description        |
cost               |
information        |
max\_capacity      |
departure\_place   |
arrival\_place     |
venue              |
start\_date        |
start\_time        |
end\_date          |
end\_time          |

Associations | belongs\_to | has\_many                    | many\_to\_many
------------ | ----------- | ---------------------------- | --------------
Group        | group       |                              |
Registration |             | registrations                |
Member       |             | members though registrations |

### Registrations
A registration belongs to an Event and to a Member.

Field              | Description
------------------ | -------------------------------
confirmed          | if false indicates waiting list

Associations | belongs\_to | has\_many                    | many\_to\_many
------------ | ----------- | ---------------------------- | --------------
Event        | event       |                              |
Member       | member      |                              |

Views
=====
The view is to be build (as far as possible) entirely with AngularJS.

There are essentially following web pages

* Home page
* About us
* Terms of Use
* Contact
* Login, request new password, edit user settings (Devise)
* Groups
* Events
* Organizations
* Members
* News

## Organizations
In the organizations view the user can search for an organization. A click on
the organization will open in the same page (hint Angular) the members. When 
clicking on a member a Group list will be opened where the user can check and
un-check groups to be associated to the member.

## Events
Shows a list of all Events. E-Mails can be send to registered users or to the
users of the group that event belongs to. The email can be send directly from
the application or it will open a email client to send the email from there.

## Print
The user should be able to design the print layout. To do so we create a model
that holds different templates that can be configured in regard to which model
and which associated model to print. We use Prawn to create a PDF file that can
be opened and printed. The workflow is shown in the list that follows

* Go to the pdf template index view
* Create a new template by selecting the base model and the associated model.
  The base model holds static fields for header and footer. The associated model
  holds the fields for the content, that is a table of the field values
* The new empty template is shown in the index view
* Pressing the edit button the fields for the header and the footer fields can
  be selected as well as the fields for the content
* In the event view the associated templates that belong to the event (base 
  class) can be selected in a select box and printed by pressing the print 
  button

### Model
The pdf template model consists of the fields `title`, `orientation`, 
`associated_class` and `column_class`.

    $ rails g model pdf_template title orientation associated_class column_class
    $ rake db:migrate

The pdf template model also has the `header`, `footer` and `header_columns`. The
`header` and `footer` have fields `left`, `middle` and `right`.

    $ rails g model header left middle right PdfTemplate:references
    $ rails g model footer left middle right PdfTemplate:references
    $ rake db:migrate

The `header_column` has the fields `content`, `title` and `size`

    $ rails g model header_column content title size PdfTemplate:references
    $ rake db:migrate

### PdfTemplate fields
In the PdfTemplate we save the attribute names of the `associated_class` and the
`column_class`. To determine the attribute names of an Event class we can use
`Event.attribute_names`. To determine the associated models of the Event class
that is the `column_class` we can use `Event.reflect_on_all_associations`.

    $ rails c
    > Event.attribute_names
     => ["id", "title", "description", "cost", "information", "departure_place",
    "arrival_place", "venue", "start_date", "start_time", "end_date", 
    "end_time", "created_at", "updated_at", "group_id"] 
    > Event.reflect_on_all_associations
     => [:group, :registrations, :members]

For further reading about inflections see [ActiveSupport::Inflector::Inflections](http://api.rubyonrails.org/classes/ActiveSupport/Inflector.html)

As an example we want to print an event with all registered members. The layout
should look like shown below

    title                      venue                start_date

    first_name | name | fee | phone

    print_date                 page # of #          start_time

We get the header and footer fields from the Event model, except for 
`print_date` and `page # of #`. These two fields we have to add to the select
box for header and footer fields. The content should be retrieved from the
Event::Registration model. Let's look at the attribute names

    > Event::Registration.attribute_names
      => ["id", "event_id", "member_id", "confirmed", "created_at", 
    "updated_at"]

Except for the `cost` field, that we can get from Event, none of the requested 
fields can be found in Event::Registration. We need to get hold of the 
associated Member model. Let's look at its fields

    > Member.attribute_names
      => ["id", "first_name", "date_of_birth", "phone", "email", "information",
    "organization_id", "created_at", "updated_at", "title"]

From the Member we can get `first_name` and `phone` but not `name`. So in order
to get the `name` we have to look at the Organization model.

    > Organization.attribute_names
      => ["id", "name", "street", "zip", "town", "country", "email", "website", 
    "information", "created_at", "updated_at", "user_id", "phone"]

And here we see that we can get the `name` field from the Organization model. 
The question now is how to retrieve the attribute names and how to add them to
the select box.

Our starting point is the `associated_class` Event and the `column_class` 
Event::Registration. From Event we get the `cost` field and from Member we can
get `first_name`. This we can get by loading the `belongs_to` association from 
Event::Registration

    > Event::Registration.reflect_on_all_registrations(:belongs_to).map(&:name)
     => [:event, :member]

To get the name we have to repeat this for Member

    > Member.reflect_on_all_associations(:belongs_to).map(&:name)
     => [:organization]

To retrieve the data programmatically we have to start at Event::Registration 
and recursively retrieve the attribute names. But first we look at how to 
create a new PdfTemplate by selecting th associated and column class.

#### Associated class and column class
When we create a new PdfTemplate we need to offer the user a select box with
the `associated_class` and dependent on the `associated_class` related 
`column_class`es. We load these in the PdfTemplatesController where we focus
only on Event at the moment.

    def load_classes
      @classes = [Event]
      @associated_classes = classes.map(&:name)
      @column_classes = grouped_classes(classes)
    end

    def grouped_classes(classes)
      grouped_classes = {}
      classes.each do |c|
        grouped_classes[c] = c.reflect_on_all_associations(:has_many)
                              .map(&:name)
      end
      grouped_classes
    end

Later on we can supplement the `classes` array with classes we want to create
PdfTemplates for. We can also retrieve all classes by issuing following commands

    Rails.application.eager_load!
    ActiveRecord::Base.descendants

The first command loads all model to the memory and the second command loads all
associatons for models loaded into the memory.

Instead on uncontrolled class loading we configure the classes we want to print
in `config/application.rb` by adding

    config.pdf_template_classes = [:organization, :member, :group, :event]

Using this configuration approach our `load_classes` changes to

    def load_classes
      @classes ||= Rails.configuration.pdf_template_classes.map do |c|
                     c.to_s.classify.constantize
                   end
      @associated_classes = @classes.map(&:klass).map(&:name)
      @column_classes = grouped_classes(@classes)
    end

The `@associated_classes` and `@column_classes` are used in
the view to populate the select boxes. The `@column_classes` is a hash that can
be used as grouped options in a select box and allows to filter the content
based on the selected associated class. This is based on a solution from 
[RailsCast](railscast.com).

In the view we use these values as follows

    <div class="field">
      </br>
      <%= f.label :associated_class %><br>
      <%= f.select :associated_class, 
        options_for_select(@associated_classes),
        { include_blank: '' }, { class: "form-control associated-class" } %>
    </div>

    <div class="form-group">
      <%= f.label :column_class %><br>
      <%= f.select :column_class, grouped_options_for_select(@column_classes),
          { include_blank: '' }, { class: "form-control column-class" } %>
    </div>

When the user now selects an associated class from the select box JavaScript is
invoked based on the "associated-class" css-class.

    jQuery ->
      $('.column-class').parent().hide()
      collections = $('.column-class').html()
      $('form').on 'change', '.associated-class', (event) ->
        clazz = $('.associated-class :selected').text()
        options = $(collections).filter("optgroup[label='#{clazz}']").html()
        if options
          $('.column-class').html(options)
          $('.column-class').parent().show()
        else
          $('.column-class').empty()
          $('.column-class').parent().hide()
        event.preventDefault()

#### Class fields
We have learned that we need to retrieve the fields we want to print not only
from the associated and column class but also from their associated classes
with the relation `:belongs_to` and `:has_one`.

Above we described how to retrieve the requested fields from models and 
associations manually. We now want to the same programmatically. We need these
fields only while editing the pdf template, so we load these in the edit action
in the PdfTemplatesController.

    def edit
      load_template
      load_attributes
    end

    def load_attributes
      @associated_class_attributes = @template.associated_class.
                                              .classify
                                              .constantize
                                              .attribute_names
      @column_class_attributes = grouped_attributes(@template.column_class
                                                             .classify
                                                             .constantize)
    end

    def grouped_attributes(klass)
      has_one = if reflection_attributes(klass, [:has_one]).empty?
                  {} 
                else
                  attributes(klass, :has_one)
                end
      belongs_to = if reflection_attributes(klass, [:belongs_to]).empty?
                     {}
                   else
                     attributes(klass, :belongs_to)
                   end

      { klass.name.underscore => klass.attribute_names }.merge(has_one)
                                                        .merge(belongs_to)
    end

    def attributes(klass, macro, hash={}, ancestors="")
      klass.reflect_on_all_associations(macro).map(&:klass).each do |k|
        ancestor = ancestor_path(ancestors, k)
        hash[ancestor] = class_attribute_names(ancestor, k)
        attributes(k, macro, hash, ancestor_path(ancestors, k))
      end
      hash
    end

    def class_attribute_names(ancestors, klass)
      klass.attribute_names.map do |a| 
        [a, "#{ancestors}.#{a}"]
      end
    end

    def ancestor_path(ancestors, klass)
      if ancestors.empty?
        klass.name.underscore
      else
        "#{ancestors}.#{klass.name.underscore}"
      end
    end


    def reflection_attributes(klass, macro)
      macros.map do |m| 
        klass.reflect_on_all_associations(m).map(&:klass)
      end.flatten
    end

### Printing
Now we have setup the configuration of a pdf template we are ready to print. For
that we will create a module that we can `include` into models that we want to
print. We save that module into `app/models/pdf_template/printer.rb`

    module PdfTemplate::Printer
      # ...

      def to_pdf(template)
      end

      # ...
    end

We include this module to the Event model

    class Event < ActiveRecord::Base
      include PdfTemplate::Printer

      # ...
    end

In order to send a print command to an Event we have to add a respective route.
The events controller is requesting a group object, that is we have to add the
route to the groups resources.

    resources :groups do
      resources :members, only: [:index], controller: 'groups/members' do
        member do
          get 'add'
          get 'remove'
        end
      end
      resources :events do
        member { post 'print', defaults: { format: 'pdf' } }
      end
    end

We supplement the events controller with the print action

    def print
      respond_to do |format|
        format.pdf do
          send_data @event.to_pdf(params[:template]), 
            content_type: Mime::PDF
        end
      end
    end

The user then goes to the event she wants to print and selects the template 
that she wants to print. We add the print UI to 
`app/views/events/_user_events.html.erb`

    <%= form_tag(print_event_path(event.group, event, params[:template]) do %>
      <%= select_tag :template, options_for_select(templates('Event')) %>
      <%= submit_tag 'Print' %>
    <% end %>

We create a helper in `app/helpers/pdf_templates_helper.rb` to create the 
options with our templates

    def templates(klass)
      PdfTemplate.all.where('associated_class = ?', klass)
                     .collect { |t| [t.title, t.id] } 
    end

Following are the steps to add print functionality to a model's view

* `include PdfTemplate::Printer` to the model
* add a route to the model's controller
  `member { post 'print', defaults: { format: 'pdf' } }`
* add the print action to the model's controller
* add the print select box and print button to the view

