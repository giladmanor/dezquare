class GamesData < ActiveRecord::Migration
  def up
    add_column :games, :data, :text
  end

  def down
    remove_column :games, :data
  end
end
