class CreateGameImageRates < ActiveRecord::Migration
  def change
    create_table :game_image_rates do |t|
      t.references :game
      t.references :image
      t.integer :value

      t.timestamps
    end
    add_index :game_image_rates, :game_id
    add_index :game_image_rates, :image_id
  end
end
