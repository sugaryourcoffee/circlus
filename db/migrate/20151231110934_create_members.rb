class CreateMembers < ActiveRecord::Migration
  def change
    create_table :members do |t|
      t.string :first_name, null: false
      t.date :date_of_birth
      t.string :phone
      t.string :email
      t.text :information
      t.integer :organization_id

      t.timestamps null: false
    end
  end
end
