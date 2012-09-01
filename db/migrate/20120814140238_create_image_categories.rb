class CreateImageCategories < ActiveRecord::Migration
  def change
    create_table :image_categories do |t|
      t.references :image
      t.references :category

      t.timestamps
    end
    add_index :image_categories, :image_id
    add_index :image_categories, :category_id
  end
end
