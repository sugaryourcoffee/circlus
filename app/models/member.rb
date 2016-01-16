class Member < ActiveRecord::Base
  belongs_to :organization
  has_and_belongs_to_many :groups
  has_many :registrations
  has_many :events, through: :registrations

  delegate :name, to: :organization
  delegate :phone, to: :organization, prefix: true

  accepts_nested_attributes_for :groups

  validates :first_name, presence: true
  validates :email, format: { with: ApplicationHelper::EMAIL_PATTERN }, 
                    allow_blank: true
end
