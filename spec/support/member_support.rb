def fill_in_member
  visit organization_path organization
  click_link "Create new member"
  fill_in "Title", with: "Dr."
  fill_in "First name", with: "Amanda"
  fill_in "Date of Birth", with: "14.02.1971"
  fill_in "Phone", with: "0173 1234567"
  fill_in "Email", with: "amanda@thesugars.de"
  fill_in "Information", with: "Beauty"
end
