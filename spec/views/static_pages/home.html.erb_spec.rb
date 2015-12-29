require 'rails_helper'

RSpec.describe "static_pages/home.html.erb", type: :view do

  it "should have the content 'Circlus'" do
    render
    expect(rendered).to have_text 'Circlus'
  end

end
