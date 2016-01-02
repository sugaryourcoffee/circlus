class Member < ActiveRecord::Base
  belongs_to :organization
  has_and_belongs_to_many :groups

  delegate :name, to: :organization
end
