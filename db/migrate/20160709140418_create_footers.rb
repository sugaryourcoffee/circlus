class CreateFooters < ActiveRecord::Migration
  def change
    create_table :footers do |t|
      t.string :left
      t.string :middle
      t.string :right
      t.references :pdf_template, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
