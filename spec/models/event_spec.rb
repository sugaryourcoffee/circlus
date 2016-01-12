require 'rails_helper'
require 'support/model_attributes'

RSpec.describe Event, type: :model do

  it "should be valid with all values set" do
    event = Event.new(event_attributes)

    expect(event.valid?).to be_truthy
    expect(event.errors.any?).to be_falsey
  end

  it "should have title" do
    event = Event.new(event_attributes(title: ""))

    expect(event.valid?).to be_falsey
    expect(event.errors.any?).to be_truthy
  end

  it "doesn't need description" do
    event = Event.new(event_attributes(description: ""))

    expect(event.valid?).to be_truthy
    expect(event.errors.any?).to be_falsey
  end

  it "doesn't need information" do
    event = Event.new(event_attributes(information: ""))

    expect(event.valid?).to be_truthy
    expect(event.errors.any?).to be_falsey
  end

  it "doesn't need departure place" do
    event = Event.new(event_attributes(departure_place: ""))

    expect(event.valid?).to be_truthy
    expect(event.errors.any?).to be_falsey
  end

  it "doesn't need arrival place" do
    event = Event.new(event_attributes(arrival_place: ""))

    expect(event.valid?).to be_truthy
    expect(event.errors.any?).to be_falsey
  end

  it "doesn't need venue" do
    event = Event.new(event_attributes(venue: ""))

    expect(event.valid?).to be_truthy
    expect(event.errors.any?).to be_falsey
  end

  it "doesn't need start date" do
    event = Event.new(event_attributes(start_date: ""))

    expect(event.valid?).to be_truthy
    expect(event.errors.any?).to be_falsey
  end

  it "doesn't need start_time" do
    event = Event.new(event_attributes(start_time: ""))

    expect(event.valid?).to be_truthy
    expect(event.errors.any?).to be_falsey
  end

  it "doesn't need end date" do
    event = Event.new(event_attributes(end_date: ""))

    expect(event.valid?).to be_truthy
    expect(event.errors.any?).to be_falsey
  end

  it "doesn't need end time" do
    event = Event.new(event_attributes(end_time: ""))

    expect(event.valid?).to be_truthy
    expect(event.errors.any?).to be_falsey
  end

end
