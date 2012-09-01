class GameTypeStageAddParams < ActiveRecord::Migration
  def up
    add_column :game_type_stages, :params, :text
  end

  def down
    remove_column :game_type_stages, :params
  end
end
