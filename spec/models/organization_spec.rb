require 'rails_helper'
require 'support/model_attributes'

RSpec.describe Organization, type: :model do

  it "should be valid with all values set" do
    organization = Organization.new(organization_attributes)

    expect(organization.valid?).to be_truthy
    expect(organization.errors.any?).to be_falsey
  end

  it "should have name" do
    organization = Organization.new(organization_attributes(name: ""))

    expect(organization.valid?).to be_falsey
    expect(organization.errors.any?).to be_truthy
  end

  it "should have street" do
    organization = Organization.new(organization_attributes(street: ""))

    expect(organization.valid?).to be_falsey
    expect(organization.errors.any?).to be_truthy
  end

  it "should have zip" do
    organization = Organization.new(organization_attributes(zip: ""))

    expect(organization.valid?).to be_falsey
    expect(organization.errors.any?).to be_truthy
  end

  it "should have town" do
    organization = Organization.new(organization_attributes(town: ""))

    expect(organization.valid?).to be_falsey
    expect(organization.errors.any?).to be_truthy
  end

  it "should have country" do
    organization = Organization.new(organization_attributes(country: ""))

    expect(organization.valid?).to be_falsey
    expect(organization.errors.any?).to be_truthy
  end

  it "doesn't need phone" do
    organization = Organization.new(organization_attributes(phone: ""))

    expect(organization.valid?).to be_truthy
    expect(organization.errors.any?).to be_falsey
  end

  it "doesn't need email" do
    organization = Organization.new(organization_attributes(email: ""))

    expect(organization.valid?).to be_truthy
    expect(organization.errors.any?).to be_falsey
  end

  it "should have valid email" do
    organization = Organization
                   .new(organization_attributes(website: "a.b@c"))

    expect(organization.valid?).to be_falsey
    expect(organization.errors.any?).to be_truthy
  end

  it "doesn't need website" do
    organization = Organization.new(organization_attributes(website: ""))

    expect(organization.valid?).to be_truthy
    expect(organization.errors.any?).to be_falsey
  end

  it "should have valid website" do
    organization = Organization
                   .new(organization_attributes(website: "http//a.b"))

    expect(organization.valid?).to be_falsey
    expect(organization.errors.any?).to be_truthy
  end

  it "doesn't need information" do
    organization = Organization.new(organization_attributes(information: ""))

    expect(organization.valid?).to be_truthy
    expect(organization.errors.any?).to be_falsey
  end

end
