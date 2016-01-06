require 'rails_helper'
require 'support/model_attributes'

RSpec.describe Organization::Search, type: :model do
  let(:user) { User.create!(user_attributes) }
  let!(:striker) { user.organizations
                       .create!(organization_attributes(name: 'Striker')) }
  let!(:strong) { user.organizations
                      .create!(organization_attributes(name: 'Strong')) }

  it "should create an organization query" do
    oq = Organization::Search.new(user.organizations, "striker")
    expect(oq).to respond_to :result
  end

  it "should find striker" do
    expect(Organization::Search.new(user.organizations, "stri").result)
                               .to match_array [striker]
  end

  it "should find strong" do
    expect(Organization::Search.new(user.organizations, "stro").result)
                               .to match_array [strong]
  end

  it "should find sugar and strong" do
    expect(Organization::Search.new(user.organizations, "str").result)
                               .to match_array [striker, strong]
  end
end
