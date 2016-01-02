class CreateJoinTable < ActiveRecord::Migration
  def change
    create_join_table :groups, :members do |t|
      t.index [:group_id, :member_id]
      t.index [:member_id, :group_id]
    end
  end
end
