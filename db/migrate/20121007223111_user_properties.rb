class UserProperties < ActiveRecord::Migration
  def up
    add_column :users, :about, :text
    add_column :users, :public_profile, :boolean, :default=>0
    add_column :users, :dez_profile, :boolean, :default=>0
    add_column :users, :suspend, :boolean, :default=>0
    
  end

  def down
  end
end
