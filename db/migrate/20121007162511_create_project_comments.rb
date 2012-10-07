class CreateProjectComments < ActiveRecord::Migration
  def change
    create_table :project_comments do |t|
      t.references :project
      t.references :user
      t.text :text

      t.timestamps
    end
    add_index :project_comments, :project_id
    add_index :project_comments, :user_id
  end
end
