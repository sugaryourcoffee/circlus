require 'rails_helper'
require 'support/model_attributes'

RSpec.describe Member::Search, type: :model do
  
  let(:user) { User.create!(user_attributes) }
  let!(:sugar) { user.organizations.create!(organization_attributes) }
  let!(:strong) { 
    user.organizations.create!(organization_attributes(name: "Strong")) 
  }
  let!(:lisa) { 
    strong.members.create!(member_attributes(first_name: "Lisa",
                                             email: "lisa@example.com")) 
  }
  let!(:pierre) { sugar.members.create!(member_attributes) }
  let!(:amanda) { 
    sugar.members.create!(member_attributes(first_name: "Amanda",
                                            email: "amanda@example.com"))
  }

  it "should create a member query" do
    mq = Member::Search.new(user.members, "su%")
    expect(mq).to respond_to :result
  end

  it "should find Lisa Strong" do
    expect(Member::Search.new(user.members, "st%").result).to match_array [lisa]
  end

  it "should find Pierre" do
    expect(Member::Search.new(user.members, "pi%")
                         .result).to match_array [pierre]
  end

  it "should find Amanda and Pierre Sugar" do
    expect(Member::Search.new(user.members, "su%")
                         .result).to match_array [pierre, amanda]
  end
end
