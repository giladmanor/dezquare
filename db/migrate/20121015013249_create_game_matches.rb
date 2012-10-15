class CreateGameMatches < ActiveRecord::Migration
  def change
    create_table :game_matches do |t|
      t.references :game
      t.references :user
      t.integer :rate

      t.timestamps
    end
    add_index :game_matches, :game_id
    add_index :game_matches, :user_id
  end
end
