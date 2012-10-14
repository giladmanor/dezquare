class GameTypeStageDisplayStepName < ActiveRecord::Migration
  def up
    add_column :game_type_stages, :progress_label,:string
  end

  def down
  end
end
