class UserTypingFlags < ActiveRecord::Migration
  def up
    remove_column :users, :has_portfolio
    add_column :users, :shopper, :boolean, :default=>1
    add_column :users, :designer, :boolean, :default=>1
    add_column :users, :pender, :boolean, :default=>1
  end

  def down
   
  end
end
