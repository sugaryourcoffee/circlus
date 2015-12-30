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


