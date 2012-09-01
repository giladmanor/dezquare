class CompleteFlagOnGame < ActiveRecord::Migration
  def up
    add_column :games, :is_complete, :boolean
    
  end

  def down
    remove_column :games, :is_complete
    
  end
end
