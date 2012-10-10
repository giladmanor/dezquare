class CategotyCodes < ActiveRecord::Migration
  def up
    add_column :categories, :code,:string
  end

  def down
  end
end
