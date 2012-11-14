class AddTagAdjectives < ActiveRecord::Migration
  def up
    add_column :tags, :adjective,:string
  end

  def down
    add_column :tags, :adjective,:string
  end
end
