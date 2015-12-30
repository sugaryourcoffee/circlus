require 'rails_helper'
require 'support/matchers'

RSpec.describe "static_pages/about.html.erb", type: :view do
  
  it "should have the content 'About Us'" do
    render
    expect(rendered).to have_selector 'h1', text: 'About Us'
  end

end
