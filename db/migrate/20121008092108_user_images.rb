class UserImages < ActiveRecord::Migration
  def up
    add_column :users, :avatar,:string
    add_column :users, :cover,:string
  end

  def down
  end
end
