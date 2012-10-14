class ProjectInfoAndFileTypes < ActiveRecord::Migration
  def up
    add_column :projects, :info,:text
    add_column :projects, :file_types,:string
  end

  def down
  end
end
