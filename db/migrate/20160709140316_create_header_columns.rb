class CreateHeaderColumns < ActiveRecord::Migration
  def change
    create_table :header_columns do |t|
      t.string :content
      t.string :title
      t.string :size
      t.string :orientation
      t.references :pdf_template, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
