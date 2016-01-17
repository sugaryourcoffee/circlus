class Group < ActiveRecord::Base

  belongs_to :user
  has_many :events
  has_and_belongs_to_many :members

  validates :name, presence: true

  validates :website, format: { with: ApplicationHelper::WEBSITE_PATTERN,
                                message: "URI is not valid" }, 
                      allow_blank: true

  validates :email, format: { with: ApplicationHelper::EMAIL_PATTERN, 
                              message: "is not valid" }, allow_blank: true

  scope :by_name, -> { order(:name) }
end

