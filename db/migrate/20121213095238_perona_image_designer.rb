class PeronaImageDesigner < ActiveRecord::Migration
  def up
    add_column :persona_images, :user_id, :integer
  end

  def down
    remove_column :persona_images, :user_id
  end
end
