class ProfileFields < ActiveRecord::Migration
  def up
    add_column :users, :direct_link, :string
    add_column :users, :education, :string
    add_column :users, :skills, :string
    
  end

  def down
    remove_column :users, :direct_link
    remove_column :users, :education
    remove_column :users, :skills
    
  end
end
