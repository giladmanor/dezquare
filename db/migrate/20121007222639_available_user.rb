class AvailableUser < ActiveRecord::Migration
  def up
    add_column :users, :available, :boolean, :default=>0
  end

  def down
  end
end
