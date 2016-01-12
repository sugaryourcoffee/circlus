class Organization < ActiveRecord::Base
  belongs_to :user
  has_many   :members, -> { order(:first_name) }

  default_scope { order(:name) }

  validates :name, :street, :zip, :town, :country, presence: true

  validates :website, format: { with: ApplicationHelper::WEBSITE_PATTERN,
                                message: "URI is not valid" }, 
                      allow_blank: true

  validates :email, format: { with: ApplicationHelper::EMAIL_PATTERN, 
                              message: "is not valid" }, allow_blank: true
end
