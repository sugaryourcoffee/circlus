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

## Layout
Our application has a header with a logo, a menue bar (Home, Help, 
Organizations, Members, Groups), showing the user signed in with a sign out 
link. When clicking on a signed in user it opens the user's settings page.

The footer has a copyright note, the applications version and links to
about us, contact and terms of use.


