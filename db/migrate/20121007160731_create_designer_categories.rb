class CreateDesignerCategories < ActiveRecord::Migration
  def change
    create_table :designer_categories do |t|
      t.references :user
      t.references :category
      t.decimal :min_price

      t.timestamps
    end
    add_index :designer_categories, :user_id
    add_index :designer_categories, :category_id
  end
end
