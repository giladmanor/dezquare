class CreateProjects < ActiveRecord::Migration
  def change
    create_table :projects do |t|
      t.string :title
      t.integer :shopper_id
      t.integer :designer_id
      t.references :category
      t.decimal :cost
      t.string :status

      t.timestamps
    end
    add_index :projects, :category_id
    
  end
end
