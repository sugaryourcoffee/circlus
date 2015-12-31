def fill_in_organization
  visit organizations_path
  click_link "Create new organization"
  fill_in "Name", with: "Sugar Your Coffee"
  fill_in "Street", with: "Sugar Street 52"
  fill_in "Zip", with: "12345"
  fill_in "Town", with: "Sugar Town"
  fill_in "Country", with: "Germany"
  fill_in "Email", with: "sugar@sugaryourcoffee.de"
  fill_in "Website", with: "http://sugaryourcoffee.de"
  fill_in "Information", with: "Information about Sugar Your Coffee"
end
