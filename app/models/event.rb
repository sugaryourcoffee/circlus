class Event < ActiveRecord::Base

  belongs_to :group
  has_many :registrations
  has_many :members, through: :registrations

  validates :title, presence: true

  scope :by_title, -> { order(:title) }
  scope :by_group_and_title, -> { order('groups.name, title') }
  scope :by_date, -> { order(:start_date, :start_time) }
  scope :by_date_desc, -> { order(start_date: :desc, start_time: :desc) }
end
