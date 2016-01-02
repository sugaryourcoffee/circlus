# Circlus
Circlus (Latin for group, convention, organization) is a web application to 
organize groups, members and events. Circlus provides following functions

* Add a Group
* Add an organization, where a organization is for example a family
* Add Members to a organization and to Groups
* Create Events associated to a Group
* Assign Members to an Event. Members can also register for an Event
* Show events in an events calendar
* Print reports for Events, that the participants
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

Associations | belongs\_to  | has\_many | many\_to\_many
------------ | ------------ | --------- | --------------
Phone        |              | phones    |
Email        |              | emails    |
Organization | organization |           |
Group        |              |           | groups 
Event        |              |           | events

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
departure\_place   |
arrival\_place     |
venue              |
start\_date        |
start\_time        |
end\_date          |
end\_time          |

Associations | belongs\_to | has\_many     | many\_to\_many
------------ | ----------- | ------------- | ------------------------------
Group        | group       |               |
Registration |             | registrations |
Member       |             |               | members, though: registrations

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

