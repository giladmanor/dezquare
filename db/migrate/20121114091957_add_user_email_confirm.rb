class AddUserEmailConfirm < ActiveRecord::Migration
  def up
    add_column :users, :email_confirm,:boolean
  end

  def down
    remove_column :users, :email_confirm
  end
end
