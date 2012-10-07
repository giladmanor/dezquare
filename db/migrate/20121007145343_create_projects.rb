class CreateProjects < ActiveRecord::Migration
  def change
    create_table :projects do |t|
      t.string :title
      t.integer :shopper_id
      t.integer :designer_id
      t.references :category
      t.references :tags
      t.decimal :cost
      t.string :status

      t.timestamps
    end
    add_index :projects, :category_id
    add_index :projects, :tags_id
  end
end
