class AddColorsToUser < ActiveRecord::Migration
  def change
    add_column :users, :dominant_colors, :text
  end
end
