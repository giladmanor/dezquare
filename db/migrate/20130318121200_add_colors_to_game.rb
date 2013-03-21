class AddColorsToGame < ActiveRecord::Migration
  def change
    add_column :games, :dominant_colors, :text
  end
end
