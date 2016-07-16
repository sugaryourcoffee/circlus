class AddColumnClassToPdfTemplate < ActiveRecord::Migration
  def change
    add_column :pdf_templates, :column_class, :string
  end
end
