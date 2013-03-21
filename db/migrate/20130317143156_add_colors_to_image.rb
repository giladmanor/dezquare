class AddColorsToImage < ActiveRecord::Migration
  def change
    add_column :images, :dominant_colors, :text
    add_column :images, :color_histogram, :text
  end
end




  

    
