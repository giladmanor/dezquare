class CreatePersonaImageBackgrounds < ActiveRecord::Migration
  def change
    create_table :persona_image_backgrounds do |t|
      t.references :persona
      t.references :user
      t.string :description
      t.string :file_path

      t.timestamps
    end
    add_index :persona_image_backgrounds, :persona_id
    add_index :persona_image_backgrounds, :user_id
  end
end
