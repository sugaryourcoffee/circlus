# Develoment
This document describes the development process. The flow is as follows.

* Static pages (home, help, about us)
* Layout (header, footer)
* Organization
* Member
* Group
* Event
* Terms of use
* Contact

## Static pages
We start off with designing our static pages. We want to have a home page, a
help page, and about us page.

We start with creating a controller with the above actions and then write our
tests.

    $ rails g controller StaticPages home help about

The StaticPages should be accessible without logging in. Therefore we have to
skip authentication in the StaticPages controller.

    skip_before_action :authenticate_user!

The generator will create model and controller tests in `spec/models` and
`spec/controllers` respectively.

We will also  create a feature test which is a test entirely testing the 
application from a user's perspective using our application on the front end.

    $ rails g rspec:feature static_pages

We now create tests for the views, the controller and then do the feature test.

## Layout
The layout has some elements that are common to all pages. The following list
depicts what we want to elaborate on the layout

* Header
* Footer
* Title

For the header and footer we create templates (\_header.html.erb, \_footer.html.erb) that are called from `app/views/layouts/application.html.erb`.

### Header
Our application has a header with a logo, a menue bar (Home, Help, 
Organizations, Members, Groups), a drop down button (Account) with submenu items
(My Contacts, Settings, Sign out).

### Footer
The footer has a copyright note, the applications version and links to
about us, contact and terms of use.

### Title
In each view we set a title value that is injected to `app/views/layouts/application.html.erb`

We set in each page the title with `<% provide(:title, "Title of the page" %>`.
Then in 
[app/views/layouts/application.html.erb](app/views/layouts/application.html.erb)
we assign the value with `<title><%= yield :title %> | Circlus %></title>`

## Organization
Next up we create an organization as this is the model that holds the members
that we want to manage. We create a controller Organizations with

    $ rails g controller Organizations index new create edit update destroy

This will create the controller as well as view and controller specs. In order
to get the controller specs running we need to configure Devise for controller
specs. In [spec/rails\_helper.rb](spec/rails_helper.rb) add following 

    require 'devise'
    # ...
    RSpec.configure do |config|
      # ...
      config.include Devise::TestHelpers, :type => :controller
      # ...
    end

In the controller spec we have to create a user and sign the user

    let(:user) { User.create!(user_attributes) }

    before { sign_in user }

The user attributes can be found in 
[spec/support/user\_attributes.rb](spec/support/user_attributes.rb)

We create a feature spec for organizations

    $ rails g rspec:feature organization

On the way of running the feature spec we need to create the Organization model

    $ rails g model Organization name:string street:string zip:string \
    > town:string country:string email:string website:string information:text \
    > phone:string

As an Organization belongs to a User we add an user\_id to Organization

    $ rails g migration add_user_id_to_organizations user_id:integer

Then we run `rake db:migrate` and `rake db:test:prepare`.

When the user signs in we want her to be forwarded to her organizations index
page. In order to that we have to add to 
[app/controllers/application\_controller.rb](app/controllers/application_controller.rb)

    def after_sign_in_path_for(resource)
      organizations_path
    end

## Member
A Member belongs to an Organization and holds individual information. Again we
create a controller, this time Members

    $ rails g controller Members

Then we run the controller tests that will fail. We add to 
[config/routes.rb](config/routes.rb) a `resources` directive for Members as a
member of Organization as a Member cannot live without an Organization.

    resources :organizations do
      resources :members
    end

and we create our Member model

    $ rails g model Member first_name:string, date_of_birth:date phone:string \
    > email:string information:text organization_id:integer

we run the migration

    $ rake db:migrate
    $ rake db:test:prepare

we add the associations in [app/models/member.rb](app/models/member.rb)

    belongs_to :organization

and to [app/models/organization.rb](app/models/organization.rb)

    has_many :members

Now we run our tests again. And successively fill in the controller until the
controller spec succeeds. Running the controller spec first makes sure we have
our routes and templates in place and know our controller is working as 
expected. The [controller spec](spec/controllers/members_controller_spec.rb) is
finished and we can proceed with testing the user experience.

Next we create a feature spec for members where we run through Circlus from a
user's perspective the way the user would interact in regard to members.

    $ rails g rspec:feature members

Currently we can only view members associtated to specific organizations. We 
also want to view all members that belong the the user's organization. In order
to achieve that we have to add following to the User model

    has_many :members, through: :organizations

In the Member controller we have to differentiate whether an organization has
been passed to the controller or not. If not we return `@user.members` otherwise
we return `@organization.members`.

When we go to the members index page we need to access the organization's name
from member. In order to have a DRY access to the member attribute we delegate
name in the Member model to Organization

    delegate :name, to: :organization

## Group
A Group belongs to a User model and it can have members and events. Again we
follow the previous steps

* create a GroupController
* run the controller specs
* create Group resources
* create a Group model
* create the associations between Group, User and Member
* create a group feature spec
* make all specs pass

We start with creating a GroupController

    $ rails g controller Group

Then we sucessively develop the Group controller guided by the controller spec.

We then create the Group routes in [config/routes.rb](config/routes.rb)

    resources :groups

Our Group model we create like so

    $ rails g model Group name:string description:text website:string \
    > user_id:integer
    $ rake db:migrate
    $ rake db:test:prepare

and add the associations to Group

    belongs_to :user 
    has_many :members

as well as to User

    has_many :groups

To associate the Member to the Group we need to add a `group_id` to Member. To
do that we create a migration

    $ rails g migration add_group_id_to_members group_id:integer
    $ rake db:migrate
    $ rake db:test:prepare

Now we can add the association to Member

    belongs_to :group

Now we create a feature spec for Group in order to test the workflow a user can
undergo when working with groups.

    $ rails g rspec:feature groups

Then we successively create the views for working with groups.

### Group Members
In the Group show view we want to add members to the group. To do that we could
use the MembersController with a lot of branching. Instead we want to create a
Groups::MembersController that has the responsibility of showing members of a
specific group and to add existing members to a group.

    $ rails g controller Groups::Members

That will create a controller in `app/controllers/groups/members_controller.rb`

and we add a resource to `config/routes.rb`. We only want to use the index 
action and two custom actions to add members and to remove members.

    resources :groups do
      resources :members, only: [:index], controller: 'groups/members' do
        member do
          get 'add'
          get 'remove'
        end
      end
    end

We also need to put our views in `app/views/groups/members/` in order to get
different views for the `Groups::MembersController`. If we don't provide views
in this directory Rails will grap the views in `app/views/groups`.

Then we run the controller spec and make it pass for index, add and remove.

*Heck I did an implementation mistake*

While making the spec for `Groups::MembersController` pass I have relized that
I have made a mistake in regard the the association between groups and members.
Groups have many members and members have many groups, while I have implemented
the first part correctly I have done wrong the second part, namely I can only
add one group to members. So we have to quickly fix that and change it into a
*many-to-many* association.

First we get rid of the `group_id` field in `Member`

    $ rails g migration remove_group_id_from_members
    $ rake db:migrate
    $ rake db:test:prepare

Next we create a join table for Group and Member

    $ rails g migration create_join_table group member
    $ rake db:migrate
    $ rake db:test:prepare

We add the `has_and_belongs_to_many` associatins in `Group`

    has_and_belongs_to_many :members

and in `Member`

    has_and_belongs_to_many :groups

Then we have to make our spec for `Groups::MembersController` pass again.

Next we add specs to `spec/features/groups_spec.rb` to list members of the
group and add existing members to the group or remove group members.

## Event
An Event belongs to a Group and a Group may have many events. We will create a
`EventsController` first.

    $ rails g controller Events

The as usual we make the controller spec pass by adding resources in 
`config/routes.rb`

    resources :events

and creating a Event model

    $ rails g model Event 

filling in the controller actions and the respective views.

When we have implemented the controller by passing the controller spec we can
proceed with implementing user experience. To so we create as usual a feature
spec for events.

    $ rails g rspec:feature events

We want from the home page access all events associated to the user. In order to
do that we add an action *user_events* to the events controller and therefore we
add a member to the events resource in `config/routes.rb`

    resources :events do
      member do
        get 'user_events'
      end
    end

We also add the action *user_events* to `app/controllers/events_controller.rb`.
The view goes to `app/views/events/user_events.html.erb`. And we add a link to
`user_events_event_path` in the `app/views/layouts/_header.html.erb`.

### Registrations
We need to associate events and members. We do that through a registration. A
registration has to be confirmed. If a registration is not confirmed the member
is on the waiting list. That is all done behind the hoods, a registration is
automatically confirmed if max capacity is not reached. All additional 
registrees are put on the waiting list. 

First as usual we create the conroller 

    $ rails g controller Events::Registrations

and make the controller spec pass by adding a resource to `config/routes.rb` as
an sub-route to events.

    resources :events do
      resources :registrations, only: [:index, :destroy], 
                controller: 'events/registrations' do
        member { get 'confirm' }
      end

      member { get 'register', to: 'events/registrations#register' }
    end

We then create a registration model

    $ rails g model Event::Registration confirmed:boolean

We need to tweak the migration so it looks like that

    create_table :registrations do |t|
      t.belongs_to :event, index: true
      t.belongs_to :member, index: true
      t.boolean :confirmed, default: true
      t.timestamps null: false
    end

Next we run 

    $ rake db:migrate
    $ rake db:test:prepare

Then we make sure that the associations in Event look like

    has_many :registrations
    has_many :members, through: :registrations

and in Member like

    has_many :registrations
    has_many :events, through: :registrations

and in Event::Registration we have

    belongs_to :event
    belongs_to :member

We don't create an own feature for registrations we rather use the event's
feature.

## Search the database
If our database grows we need means to easily and fast access organizations,
members, groups and events. In order to do that we have to create a search
possibility. If we want to search for members by first name, last name and 
email address we would issue following SQL query

    $ rails dbconsole
    > password:
    circlus_development=> select organizations.name, members.first_name
    > members.email from organizations inner join members
    > on members.organization_id = organizations.id
    > where lower(organizations.name) like 'st%'
    > or lower(members.first_name) like 'am%'
    > or lower(members.email) like 'pierre@%'
    > order by members.email like 'pierre@%' desc, organizations.name asc;
     name   | first_name |          email
    --------+------------+--------------------------
     Sugar  | Pierre     | pierre@example.com
     Sugar  | Pierre     | pierre@sugaryourcoffee.de
     Strong | Lisa       | lisa@example.com
     Sugar  | Amanda     | amanda@example.com

As we are selecting from different tables we first have to create an inner join
and then have to filter the database in the where clause. Finaly we order first
on email addresses and then on name.

We want to implement the queries in a generic way so we can use them searching
for different tables and fields. To do that we create a fuzzy search class
based on the book 
[Rails, Angular, Postgres, and Bootstrap](https://pragprog.com/book/dcbang/rails-angular-postgres-and-bootstrap) 
from David Bryant Copeland.

In our fuzzy search we will conduct the query with all fields like so

    circlus_development=> select * from organizations 
    > inner join members on members.organization_id = organizations.id 
    > where 
    > lower(organizations.name) like 'st%' or
    > lower(members.first_name) like 'am%' or 
    > lower(members.email) like 'pierre@%' 
    > order by members.email like 'pierre@%' desc, organizations.name asc;

