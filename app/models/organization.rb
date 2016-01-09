class Organization < ActiveRecord::Base
  belongs_to :user
  has_many   :members, -> { order(:first_name) }

  default_scope { order(:name) }
end
