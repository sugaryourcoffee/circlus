require 'rails_helper'
require 'support/model_attributes'

RSpec.describe Member, type: :model do

  it "should respond to attributes" do
    member = Member.new
    expect(member).to respond_to :phones
    expect(member).to respond_to :emails
  end

  it "should be valid with all values set" do
    member = Member.new(member_attributes)

    expect(member.valid?).to be_truthy
    expect(member.errors.any?).to be_falsey
  end

  it "should have first_name" do
    member = Member.new(member_attributes(first_name: ""))

    expect(member.valid?).to be_falsey
    expect(member.errors.any?).to be_truthy
  end

  it "doesn't need title" do
    member = Member.new(member_attributes(title: ""))

    expect(member.valid?).to be_truthy
    expect(member.errors.any?).to be_falsey
  end

  it "doesn't need date of birth" do
    member = Member.new(member_attributes(date_of_birth: ""))

    expect(member.valid?).to be_truthy
    expect(member.errors.any?).to be_falsey
  end

  it "doesn't need phone" do
    member = Member.new(member_attributes(phone: ""))

    expect(member.valid?).to be_truthy
    expect(member.errors.any?).to be_falsey
  end

  it "doesn't need email" do
    member = Member.new(member_attributes(email: ""))

    expect(member.valid?).to be_truthy
    expect(member.errors.any?).to be_falsey
  end

  it "should have valid email" do
    member = Member
                   .new(member_attributes(email: "a.b@c"))

    expect(member.valid?).to be_falsey
    expect(member.errors.any?).to be_truthy
  end

  it "doesn't need information" do
    member = Member.new(member_attributes(information: ""))

    expect(member.valid?).to be_truthy
    expect(member.errors.any?).to be_falsey
  end

end
