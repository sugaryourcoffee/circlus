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

We set in each page the title with `<% provide(:title, "Title of the page" %>.
Then in 
[app/views/layouts/application.html.erb](app/views/layouts/application.html.erb)
we assign the value with `<title><%= yield :title %> | Circlus %></title>

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

