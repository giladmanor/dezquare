class PersonaImageProperties < ActiveRecord::Migration
  def up
    remove_column :persona_images, :user_id
    add_column :persona_images, :image_id,:integer
    remove_column :persona_images, :description
    remove_column :persona_images, :file_path
  end

  def down
    add_column :persona_images, :user_id, :integer
    remove_column :persona_images, :image_id
    add_column :persona_images, :description, :string
    add_column :persona_images, :file_path, :string
  end
end
