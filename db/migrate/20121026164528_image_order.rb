class ImageOrder < ActiveRecord::Migration
  def up
    add_column :images, :ord,:integer
  end

  def down
  end
end
