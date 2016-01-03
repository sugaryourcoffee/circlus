class Event < ActiveRecord::Base

  belongs_to :group
  has_many :registrations
  has_many :members, through: :registrations

end
