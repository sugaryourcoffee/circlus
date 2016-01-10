class Group < ActiveRecord::Base

  belongs_to :user
  has_many :events, -> { order(:title) }
  has_and_belongs_to_many :members

  default_scope { order(:name) }
end
