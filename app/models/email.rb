class Email < ActiveRecord::Base
  CATEGORIES = [['Business', 0], ['Private', 1], ['Other', 2]]
  belongs_to :member
end
