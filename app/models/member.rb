class Member < ActiveRecord::Base
  belongs_to :organization
  delegate :name, to: :organization
end
