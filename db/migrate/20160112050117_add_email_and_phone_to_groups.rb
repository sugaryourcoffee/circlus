class AddEmailAndPhoneToGroups < ActiveRecord::Migration
  def change
    add_column :groups, :email, :string
    add_column :groups, :phone, :string
  end
end
