class AugmentCategory < ActiveRecord::Migration
  def up
    add_column :categories, :icon, :string
  end

  def down
  end
end
