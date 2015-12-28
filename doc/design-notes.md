# Circlus
Circlus (Latin for group, convention, community) is a web application to 
organize groups, members and events. Circlus provides following functions

* Add a Group
* Add a Community, where a community is for example a family
* Add Members to a Community and to Groups
* Create Events associated to a Group
* Assign Members to an Event. Members can also register for an Event
* Show events in an events calendar
* Print reports for Events, that the participants
* Print contact lists
* Reports may be configurable in fields to print

# Models
The Circlus application consists of following objects

Object    | Description                        | Association
--------- | ---------------------------------- | ------------------------------
User      | user of the application            | Member
Member    | a person that may be a User        | Community, Group, Event, User
Community | has an address and a name          | Member
Group     | organization that organizes events | Member, Event
Event     | event organized by a group         | Event, Participant (Member)

## Member
A Member belongs to a Community and may belong to a group.

Field           | Description
--------------- | --------------
first\_name     | 
date\_of\_birth |
information     |

Associations | belongs\_to | has\_many | many\_to\_many
------------ | ----------- | --------- | --------------
Phone        |             | phones    |
Email        |             | emails    |
Community    | community   |           |
Group        |             |           | groups 
Event        |             |           | events

## Community
A community may have many members.

Field       | Description
----------- | -----------
name        |
street      |
zip         |
town        |
country     |
email       |
web         |
information |

Associations | belongs\_to | has\_many | many\_to\_many
------------ | ----------- | --------- | --------------
Member       |             | members   |

## Group
A group is organizing events.

Field       | Description
----------- | -----------
name        |
description |

Associations | belongs\_to | has\_many | many\_to\_many
------------ | ----------- | --------- | --------------
Member       |             | members   |
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
event\_start\_date |
event\_start\_time |
event\_end\_date   |
event\_end\_time   |

Associations | belongs\_to | has\_many | many\_to\_many
------------ | ----------- | --------- | --------------
Group        | group       |           |
Member       |             | members   |

