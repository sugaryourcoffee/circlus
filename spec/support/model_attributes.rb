def user_attributes(override = {})
  {
    email: "pierre@sugaryourcoffee.de",
    password: "secret",
    password_confirmation: "secret"
  }.merge(override)
end

def organization_attributes(override = {})
  {
    name:        "Sugar",
    street:      "Sugar Street 52",
    zip:         "12345",
    town:        "Sugar Town",
    country:     "Sugar Country",
    email:       "sugar@sugaryourcoffee.de",
    website:     "http://sugaryourcoffee.de",
    information: "Information about Sugar Your Coffee",
    phone:       "12345678"
  }.merge(override)
end

def member_attributes(override = {})
  {
    first_name:    "Pierre",
    title:         "Philosopher",
    date_of_birth: "01.01.2016",
    phone:         "1234 568790",
    email:         "pierre@sugaryourcoffee.de",
    information:   "Information about Pierre"
  }.merge(override)
end

def group_attributes(override = {})
  {
    name:        "Hackatron",
    description: "Contest of hackers",
    email:       "group@example.com",
    phone:       "12344555",
    website:     "http://www.hackatron.com"
  }.merge(override)
end

def event_attributes(override = {})
  {
    title:           "Hack the Heck",
    description:     "Contest of heck hackers",
    cost:            10,
    information:     "Please bring your own laptop",
    departure_place: "Bus stop",
    arrival_place:   "Train station",
    venue:           "Cinema",
    start_date:      "02.01.2016",
    start_time:      "6:00",
    end_date:        "02.01.2016",
    end_time:        "18:00"
  }.merge(override)
end

