class PersonaImageRating < ActiveRecord::Migration
  def up
    add_column :persona_images, :rate, :integer
  end

  def down
    remove_column :persona_images, :rate
  end
end
