class CreateEventRegistrations < ActiveRecord::Migration
  def change
    create_table :event_registrations do |t|
      t.belongs_to :event, index: true
      t.belongs_to :member, index: true
      t.boolean :confirmed, default: true
      t.timestamps null: false
    end
  end
end
