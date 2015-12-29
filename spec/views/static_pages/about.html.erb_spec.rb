require 'rails_helper'

RSpec.describe "static_pages/about.html.erb", type: :view do
  
  it "should have the content 'About Us'" do
    render
    expect(rendered).to have_text 'About Us'
  end

end
