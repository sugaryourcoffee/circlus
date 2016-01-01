def fill_in_group
  visit groups_path
  click_link "Create new group"
  fill_in "Name", with: "Developers"
  fill_in "Website", with: "http://sugaryourcoffee.de/developers"
  fill_in "Description", with: "Description about group developers"
end
