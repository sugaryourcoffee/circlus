class Organization < ActiveRecord::Base
  belongs_to :user
  has_many   :members, -> { order(:first_name) }

  default_scope { order(:name) }

  validates :name, :street, :zip, :town, :country, presence: true

  WEBSITE_PATTERN = /\Ahttps?:\/\/(\w+[\w\d\-_]*(\/|\.)?)*\w{2,4}(:\d+)?\z/
  validates :website, format: { with: WEBSITE_PATTERN,
                                message: "URI is not valid" }, 
                      allow_blank: true

  EMAIL_PATTERN = /\A[\w!#\$%&'*+\/=?`{|}~^-]+(?:\.[\w!#\$%&'*+\/=?`{|}~^-]+)*@(?:[a-zA-Z0-9-]+\.)+[a-zA-Z]{2,6}\Z/ 
  validates :email, format: { with: EMAIL_PATTERN, 
                              message: "is not valid" }, allow_blank: true
end
