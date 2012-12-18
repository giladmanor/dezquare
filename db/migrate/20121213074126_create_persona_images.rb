class CreatePersonaImages < ActiveRecord::Migration
  def change
    create_table :persona_images do |t|
      t.references :persona
      t.string :description
      t.string :file_path

      t.timestamps
    end
    add_index :persona_images, :persona_id
  end
end
