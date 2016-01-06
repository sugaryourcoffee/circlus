require 'rails_helper'
require 'support/model_attributes'

RSpec.describe Event::Search, type: :model do
  let(:user) { User.create!(user_attributes) }
  let(:group) { user.groups.create!(group_attributes) }
  let!(:rubytron) { group.events.create!(event_attributes(title: 'Rubytron')) }
  let!(:elixirtron) { group.events
                           .create!(event_attributes(title: 'elixirtron')) }
  let!(:elmtron) { group.events.create!(event_attributes(title: 'elmtron')) }

  it "should create a event query" do
    gq = Event::Search.new(group.events, "elixir")
    expect(gq).to respond_to :result
  end

  it "should find rubytron" do
    expect(Event::Search.new(group.events, "rub").result)
                        .to match_array [rubytron]
  end

  it "should find elmtron" do
    expect(Event::Search.new(group.events, "elix").result)
                        .to match_array [elixirtron]
  end

  it "should find elixirtron and elmtron" do
    expect(Event::Search.new(group.events, "el").result)
                        .to match_array [elixirtron, elmtron]
  end
end
