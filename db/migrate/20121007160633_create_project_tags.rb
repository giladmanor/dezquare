class CreateProjectTags < ActiveRecord::Migration
  def change
    create_table :project_tags do |t|
      t.references :tag
      t.references :project

      t.timestamps
    end
    add_index :project_tags, :tag_id
    add_index :project_tags, :project_id
  end
end
