class CreateOrganizations < ActiveRecord::Migration
  def change
    create_table :organizations do |t|
      t.string :name, null: false
      t.string :street, null: false
      t.string :zip, null: false
      t.string :town, null: false
      t.string :country, null: false
      t.string :email
      t.string :website
      t.text :information

      t.timestamps null: false
    end
  end
end
