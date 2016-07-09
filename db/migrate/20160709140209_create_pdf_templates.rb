class CreatePdfTemplates < ActiveRecord::Migration
  def change
    create_table :pdf_templates do |t|
      t.string :title
      t.string :associated_class

      t.timestamps null: false
    end
  end
end
