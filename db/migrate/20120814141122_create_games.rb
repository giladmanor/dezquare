class CreateGames < ActiveRecord::Migration
  def change
    create_table :games do |t|
      t.references :game_type
      t.references :game_type_stage
      t.references :user
      
      t.timestamps
    end
    add_index :games, :user_id
    add_index :games, :game_type_id
    add_index :games, :game_type_stage_id
  end
end
