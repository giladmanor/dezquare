class CreateImages < ActiveRecord::Migration
  def change
    create_table :images do |t|
      t.references :user
      t.string :name
      t.string :file_path
      
      t.timestamps
    end
    add_index :images, :user_id
  end
end
