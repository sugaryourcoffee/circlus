require 'rails_helper'
require 'support/model_attributes'

RSpec.describe Group::Search, type: :model do
  let(:user) { User.create!(user_attributes) }
  let!(:operators) { user.groups.create!(group_attributes(name: 'operators')) }
  let!(:devs) { user.groups.create!(group_attributes(name: 'devs')) }
  let!(:security) { user.groups.create!(group_attributes(name: 'security')) }
  let!(:sentinel) { user.groups.create!(group_attributes(name: 'sentinel')) }

  it "should create a group query" do
    gq = Group::Search.new("oper")
    expect(gq).to respond_to :result
  end

  it "should find devs" do
    expect(Group::Search.new("dev").result).to match_array [devs]
  end

  it "should find operators" do
    expect(Group::Search.new("op").result).to match_array [operators]
  end

  it "should find security and sentinel" do
    expect(Group::Search.new("se").result).to match_array [security, sentinel]
  end
end
