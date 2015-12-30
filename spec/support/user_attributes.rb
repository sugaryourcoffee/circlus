def user_attributes(override = {})
  {
    email: "pierre@sugaryourcoffee.de",
    password: "secret",
    password_confirmation: "secret"
  }.merge(override)
end
