class CreateGameDesigners < ActiveRecord::Migration
  def change
    create_table :game_designers do |t|
      t.references :game
      t.references :user

      t.timestamps
    end
    add_index :game_designers, :game_id
    add_index :game_designers, :user_id
  end
end
