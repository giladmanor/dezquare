class ImageCategotyCategoryReference < ActiveRecord::Migration
  def up
    add_column :image_categories, :category_id, :integer
    
  end

  def down
    remove_column :users, :category_id
    
  end
end
