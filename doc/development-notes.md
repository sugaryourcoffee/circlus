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
    > where organizations.user_id = 3 and (lower(organizations.name) like 'st%'
    > or lower(members.first_name) like 'am%'
    > or lower(members.email) like 'pierre@%')
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

### Search members
This is the query from our introduction example. In our search we will conduct 
the query with all fields like so

    circlus_development=> select * from organizations 
    > inner join members on members.organization_id = organizations.id 
    > where 
    > organizations.user_id = 3 and 
    > (
    >  lower(organizations.name) like 'st%' or
    >  lower(members.first_name) like 'am%' or 
    >  lower(members.email) like 'pierre@%'
    > ) order by members.email like 'pierre@%' desc, organizations.name asc;

The corresponding active record query would look like this

    User.find(3).members.joins(:organization)
        .where("lower(organizations.name) like :name or" +
               "lower(members.first_name) like :first_name or" +
               "lower(members.email)      like :email", {
                 name: "st%",
                 first_name: "am%",
                 email: "pierre@%"
               }).order("members.email like 'pierre@%' "+
                        " desc, organizations.name asc")

We implement the member search in 
[app/model/member/search.rb](app/model/member/search.rb) and use it in
[app/controller/members\_controller.rb](app/controllers/members_controller.rb).
When it works in the view and our tests run we implement it in the other views
where we want to search for members.

When filtering registrations we need to tweak the invokation of 
`Member::Search`.

    search = Member::Search.new(@event.members, params[:keywords])
    @event.registrations.joins(:member).where(member_id: search.result)

In the event view at 
[app/views/events/registrations/index.html.erb](app/views/events/registrations/index.html.erb) 
we also have to search field, one for members that are not registered for the 
event and one for registrations. In order to differentiate between those to 
when committing a search we can eather check for `params[:commit] value or we
could use differnt keys for the search term. In the controller we check for
`params[:commit] == "Find members"` and 
`params[:commit] == "Find registrations"`. But as soon as we localizing our 
view this won't help.

### Search organization
To search an organization we can search for name and email in the organization's
table

    circlus_development=> select * from organizations 
    > where 
    > lower(organizations.name) like 'su%' or
    > lower(organizations.email) like 'web@%' 
    > order by organizations.email like 'web@%' desc, organizations.name asc;

### Search group
To search a group we have only one field, namely name, to search for

    circlus_development=> select * from groups 
    > where 
    > lower(groups.name) like 'pr%' or
    > order by groups.name asc;

### Search event
Events can also only be search for one field, the title field

    circlus_development=> select * from events 
    > where 
    > lower(events.title) like 'ha%' or
    > order by events.title asc;

## Create and edit member
A member may belong to groups. We want to add or remove a member to or from a
group in the member's form page. To do that we have to list all avaialable
groups as a checkbox. In 
[app/views/members/_form.html.erb](app/views/members/_form.html.erb) we loop 
through the groups and create for each group a `check_box_tag`.

    <% @user.groups.each do |group| %>
      <%= hidden_field_tag "member[group_ids][]", nil %>
      <div class="form-group">
        <%= check_box_tag "member[group_ids][]", group.id, 
          @member.groups.include?(group), id: dom_id(group) %>
        <%= label_tag dom_id(group), group.name %>
      </div>
    <% end %>

In the controller 
[app/controllers/members_controller.rb](app/views/controllers/members_controller.rb) 
we have to permit the `group_ids` so they get set through a member create or
update.

    def member_params
      member_params = params[:member]
      member_params ? member_params.permit(:title, :first_name, :date_of_birth,
                                           :phone, :email, :information,
                                           { group_ids: [] }) : {}
    end

## Deterine upcoming Birthdays and Events
We want to determine whether there are members that have birthday today, next 7 days or next 30 days.

Today we can determine with

    @today = members.where('extract(day from date_of_birth) = ? and extract(month from date_of_birth) = ?', today.day, today.month) 

Next seven days is a little bit more involved. Asuming we have a date of birth
on 2000-01-14 and we want to check whether the date is in a date range.

Case | Start Date | Date of Birth | End Date
---- | ---------- | ------------- | ----------
1    | 01.10.2016 | 01.10.2000    | 01.10.2016
2    | 01.10.2016 | 05.10.2000    | 07.11.2016
3    | 01.10.2016 | 05.11.2000    | 07.11.2016
4    | 20.12.2016 | 24.12.2000    | 07.01.2017
5    | 20.12.2016 | 02.01.2000    | 07.01.2017

Case 1 is quite simple

    SD.month == DoB.month and SD.day == DoB.day

Case 2 we have to do following comparisson

    if SD.month <= DoB.month and DoB.month < ED.month
      SD.day <= DoB.day
    elsif SD.month < DoB.month and DoB.month <= ED.month
      DoB.day <= ED.day
    end

Case 3 is covered by Case 2

Case 4 we have

    if SD.year = BoD.year
      # same as case 2
    else
      if DoB.month <= ED.month
        DoB.day <= ED.day
      end
    end 

Case 5 is covered by Case 4

But there is an easier way to check whether a date is in a given interval. By
replacing the checked date's year with the intervals year we can check with
between function. 
(found at [stackoverflow](http://stackoverflow.com/questions/6913719/postgres-birthdays-selection)
This will not respect ranges between years but we will work on that shortly.

    create or replace function replace_year_of(date)
      returns date
    as $$
      select (date_trunc('year', now()::date)
              + age($1, 'epoch'::date)
              - (extract(year from age($1, 'epoch'::date)) || ' years')::interval)::date;
    $$ language sql stable strict;

We examine what the code does

    select (date_trunc('year', '2016-01-16'::date));
    2016-01-01 00:00:00+01

    select (age('2000-05-12', 'epoch'::date));
    30 years 4 mons 11 days

    select (extract(year from age('2000-05-12', 'epoch'::date)) || 'years'::interval;
    30 years

The result then is `2016-01-01 + 30 years 4 mons 11 days - 30 years` which is
`2016-05-12`.

Then we can use it like so

    Members.where('replace_year_of(date_of_birth) between :start and :end', { start: '2016-01-16', end: '2016-02-16' })

But there is a little caveat if the range is between years. Therefore we have 
to check if the birthdate is in the old or in the new year and have to replace 
the birthdate's year with the respective interval year. 

    create or replace function replace_year_of(birthdate date, start_date date, end_date date)
      returns date
    as $$
    declare
      base_date date := start_date;
    begin
      if (date_part('year', start_date) < date_part('year', end_date)) then
        if (date_part('month', date) < date_part('month', start_date)) then
          base_date := end_date;
        end if;
      end if;

      select (date_trunc('year', base_date::date)
      + age($1, 'epoch'::date)
      - (extract(year from age($1, 'epoch'::date)) || ' years')::interval)::date;
    end;
    $$ language plpgsql;

    Members.where('replace_year_of(date_of_birth, :start, :end) between :start and :end', { start: '2016-01-16', end: '2016-02-16' })

But if we anyhow will have to provide the start and end of the interval we can
also right away check whether the given date is within the date range.

    create or replace function date_is_in_range(birthdate date, 
                                                start_date date, 
                                                end_date date)
      returns boolean as $$

    declare
      base_date date := start_date;
      result boolean;
    begin
      if (date_part('year', start_date) < date_part('year', end_date)) then
        if (date_part('month', birthdate) < date_part('month', start_date)) then
          base_date := end_date;
        end if;
      end if;

      select 
        (
          date_trunc('year', base_date)
          + age(birthdate, 'epoch'::date)
          - (extract(year from age(birthdate, 'epoch'::date)) || ' years'
                    )::interval
        )::date between start_date and end_date into result;
      return result;
    end;
    $$ language plpgsql;

To enter the function we can do that in rails' dbconsole but it is much more
conveniant to write it to a file, e.g. `db/functions.sql` and then load it with
`\i db/functions.sql`.

But we rather want to automatically create the function, e.g. when we deploy 
the application without explicitly loading a file. In order to do that we 
create a migration where we create the function.

    $ rails g migration add_postgrest_function_date_is_in_range

Then we add to the migration following code

    def up
      connection.execute(%q{
        create or replace function date_is_in_range(birthdate date,
                                                    start_date date,
                                                    end_date date)
        ...
      })
    end

    def up
      connection.execute(%q{
        drop function date_is_in_range(date, date, date);
        ...
      })
    end

To also be able to run our specs we have to set the schema\_format to sql.

    $ vi config/application.rb
    config.active_record.schema_format = :sql

We need this configuration in order the PosgreSQL function is available in the
test database. But this has the disadvantage that we can use our application 
only with PostgreSQL.

Before we can run the migration we have to drop the function otherwise the the
migration won't run

    $ rals dbconsole
    circlus_development=> drop function date_is_in_range(date, date, date);

And finally as usual run the migration

    $ rake db:migrate

## Application version number
To add an application number we tag our commit and use the tag as the version
number.

First we tag our commit

    $ git checkout -b v1.0-stable
    $ git push --set-upstream origin v1.0-stable
    $ git tag -a v1.0.0 -m "Circlus V1.0.0 - Release 2016-01-17"
    $ git push --tags

What we did is check out a new branch and push that branch to Github. Nex we 
create a tag and push the tag to Github.

Now we create the version number from the tag. We create a version file in 
development mode by adding the following snippet to `config/application.rb`.

    if Rails.env.development?
      File.open('config/version', 'w') do |file|
        file.write `git describe --tags --abbrev=0`
      end
    end

    module Circlus
      class Application < Rails::Application
        config.version = File.read('config/version')
      end
    end

In `app/views/layouts/_footer.html.erb` we add the version number as

    <a href="https://github.com/sugaryourcoffee/circlus",
      target="_blank">Circlus <%= Rails.configuration.version %></a>
      by Sugar Your Coffee

To create `config/version` and `Rails.configuration.version` we have to restart
the server in development mode.

    $ rails s

After we have successfully run our specs we commit the changes to github.

    $ git push

Then we check out the master branch and merge our changes

    $ git checkout master
    $ git merge v1.0-stable

Then we push our master branch to Github and deploy our application

    $ git push
    $ cap production deploy

## Sources

