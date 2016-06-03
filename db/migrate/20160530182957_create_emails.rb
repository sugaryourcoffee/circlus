class CreateEmails < ActiveRecord::Migration
  def change
    create_table :emails do |t|
      t.string :category
      t.string :address
      t.references :member, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
