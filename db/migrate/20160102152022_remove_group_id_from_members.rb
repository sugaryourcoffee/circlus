class RemoveGroupIdFromMembers < ActiveRecord::Migration
  def change
    remove_column :members, :group_id, :integer
  end
end
