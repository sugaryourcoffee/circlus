class PdfTemplate < ActiveRecord::Base
  has_many :header_columns
  has_one  :header
  has_one  :footer

  accepts_nested_attributes_for :header_columns, allow_destroy: true
  accepts_nested_attributes_for :header, allow_destroy: true
  accepts_nested_attributes_for :footer, allow_destroy: true
end
