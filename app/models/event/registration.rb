class Event::Registration < ActiveRecord::Base
  belongs_to :event
  belongs_to :member
end
