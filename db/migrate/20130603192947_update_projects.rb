class UpdateProjects < ActiveRecord::Migration
  def change
    add_column :projects, :deadline, :date
    rename_column :projects, :cost, :budget
  end

end
