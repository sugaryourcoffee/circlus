class PdfTemplate < ActiveRecord::Base
  has_many :header_columns, dependent: :destroy
  has_one  :header, dependent: :destroy
  has_one  :footer, dependent: :destroy

  accepts_nested_attributes_for :header_columns, allow_destroy: true
  accepts_nested_attributes_for :header, allow_destroy: true
  accepts_nested_attributes_for :footer, allow_destroy: true

  validates :title, presence: true
  validates :associated_class, presence: true
  validates :column_class, presence: true
 end
