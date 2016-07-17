class User < ActiveRecord::Base
  include PdfTemplate::Printer

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :organizations
  has_many :members, through: :organizations 
  has_many :groups
  has_many :events, through: :groups
end
