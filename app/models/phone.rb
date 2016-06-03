class Phone < ActiveRecord::Base
  CATEGORIES = [['Business', 0], ['Business Mobile', 1], ['Private Mobile', 2]]

  belongs_to :member
end
