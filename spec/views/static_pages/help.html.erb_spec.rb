require 'rails_helper'

RSpec.describe "static_pages/help.html.erb", type: :view do
  
  it "should have the content 'Help'" do
    render
    expect(rendered).to have_text 'Help'
  end

end
