class Member < ActiveRecord::Base
  belongs_to :organization
  has_and_belongs_to_many :groups
  has_many :registrations
  has_many :events, through: :registrations

  delegate :name, to: :organization

  accepts_nested_attributes_for :groups
end
