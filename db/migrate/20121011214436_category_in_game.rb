class CategoryInGame < ActiveRecord::Migration
  def up
    add_column :games, :category_id,:integer
    add_column :games, :project_id,:integer
    add_column :games, :max_price,:decimal
    
  end

  def down
  end
end
