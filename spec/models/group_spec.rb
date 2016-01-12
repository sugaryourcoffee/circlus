require 'rails_helper'
require 'support/model_attributes'

RSpec.describe Group, type: :model do

  it "should be valid with all values set" do
    group = Group.new(group_attributes)

    expect(group.valid?).to be_truthy
    expect(group.errors.any?).to be_falsey
  end

  it "should have name" do
    group = Group.new(group_attributes(name: ""))

    expect(group.valid?).to be_falsey
    expect(group.errors.any?).to be_truthy
  end

  it "doesn't need phone" do
    group = Group.new(group_attributes(phone: ""))

    expect(group.valid?).to be_truthy
    expect(group.errors.any?).to be_falsey
  end

  it "doesn't need email" do
    group = Group.new(group_attributes(email: ""))

    expect(group.valid?).to be_truthy
    expect(group.errors.any?).to be_falsey
  end

  it "should have valid email" do
    group = Group
                   .new(group_attributes(website: "a.b@c"))

    expect(group.valid?).to be_falsey
    expect(group.errors.any?).to be_truthy
  end

  it "doesn't need website" do
    group = Group.new(group_attributes(website: ""))

    expect(group.valid?).to be_truthy
    expect(group.errors.any?).to be_falsey
  end

  it "should have valid website" do
    group = Group
                   .new(group_attributes(website: "http//a.b"))

    expect(group.valid?).to be_falsey
    expect(group.errors.any?).to be_truthy
  end

  it "doesn't need description" do
    group = Group.new(group_attributes(description: ""))

    expect(group.valid?).to be_truthy
    expect(group.errors.any?).to be_falsey
  end

end
