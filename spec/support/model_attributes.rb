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
