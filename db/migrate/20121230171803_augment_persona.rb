class AugmentPersona < ActiveRecord::Migration
  def up
    add_column :personas, :vid, :string
  end

  def down
    remove_column :personas, :vid
  end
end
