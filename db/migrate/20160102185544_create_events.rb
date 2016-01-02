class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.string :title, null: false
      t.text :description
      t.integer :cost, default: 0
      t.text :information
      t.string :departure_place
      t.string :arrival_place
      t.string :venue
      t.date :start_date
      t.time :start_time
      t.date :end_date
      t.time :end_time

      t.timestamps null: false
    end
  end
end
