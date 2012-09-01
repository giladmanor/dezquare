class CreateImageComments < ActiveRecord::Migration
  def change
    create_table :image_comments do |t|
      t.references :image
      t.string :type
      t.string :text
      t.integer :loc_x
      t.integer :loc_y

      t.timestamps
    end
    add_index :image_comments, :image_id
  end
end
