class FixUserTypeDefaults < ActiveRecord::Migration
  def up
    
    remove_column :users, :shopper
    remove_column :users, :designer
    remove_column :users, :pender
    
    add_column :users, :shopper, :boolean, :default=>0
    add_column :users, :designer, :boolean, :default=>0
    add_column :users, :pender, :boolean, :default=>0
  end

  def down
  end
end
