class CreateGroups < ActiveRecord::Migration
  def change
    create_table :groups do |t|
      t.string :name, null: false
      t.text :description
      t.string :website
      t.integer :user_id

      t.timestamps null: false
    end
  end
end
