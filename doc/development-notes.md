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
Our application has a header with a logo, a menue bar (Home, Help, 
Organizations, Members, Groups), showing the user signed in with a sign out 
link. When clicking on a signed in user it opens the user's settings page.

The footer has a copyright note, the applications version and links to
about us, contact and terms of use.


