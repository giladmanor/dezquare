class ArgumentsToGameTypeStage < ActiveRecord::Migration
  def up
    rename_column :game_type_stages, :params, :arguments
  end

  def down
  end
end
