class CreateGameTypeStages < ActiveRecord::Migration
  def change
    create_table :game_type_stages do |t|
      t.references :game_type
      t.integer :ord
      t.string :imp

      t.timestamps
    end
    add_index :game_type_stages, :game_type_id
  end
end
