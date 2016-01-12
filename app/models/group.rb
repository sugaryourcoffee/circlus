class Group < ActiveRecord::Base

  belongs_to :user
  has_many :events, -> { order(:title) }
  has_and_belongs_to_many :members

  default_scope { order(:name) }

  validates :name, presence: true

  validates :website, format: { with: ApplicationHelper::WEBSITE_PATTERN,
                                message: "URI is not valid" }, 
                      allow_blank: true

  validates :email, format: { with: ApplicationHelper::EMAIL_PATTERN, 
                              message: "is not valid" }, allow_blank: true
end

