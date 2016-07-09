class AddOrientationToPdfTemplate < ActiveRecord::Migration
  def change
    add_column :pdf_templates, :orientation, :string
  end
end
