class Member < ActiveRecord::Base
  belongs_to :organization
  has_and_belongs_to_many :groups
  has_many :registrations
  has_many :events, through: :registrations
  has_many :phones
  has_many :emails

  delegate :name, to: :organization
  delegate :phone, to: :organization, prefix: true

  accepts_nested_attributes_for :groups
  accepts_nested_attributes_for :phones, allow_destroy: true

  validates :first_name, presence: true
  validates :email, format: { with: ApplicationHelper::EMAIL_PATTERN }, 
                    allow_blank: true

  scope :by_first_name, -> { order(:first_name) }
  scope :by_name_and_first_name, -> { order('organizations.name, first_name') }
  scope :by_date_of_birth, -> { 
    order('extract(month from date_of_birth), extract(day from date_of_birth)') 
  }
end
