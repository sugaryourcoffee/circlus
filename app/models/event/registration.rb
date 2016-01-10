class Event::Registration < ActiveRecord::Base
  belongs_to :event
  belongs_to :member
  has_one :organization, through: :member
end
