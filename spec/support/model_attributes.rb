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
    information: "Information about Sugar Your Coffee"
  }.merge(override)
end

def member_attributes(override = {})
  {
    first_name:    "Pierre",
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
    website:     "http://www.hackatron.com"
  }.merge(override)
end
