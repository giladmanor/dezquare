class CreateUserLanguages < ActiveRecord::Migration
  def change
    create_table :user_languages do |t|
      t.references :user
      t.references :language

      t.timestamps
    end
    add_index :user_languages, :user_id
    add_index :user_languages, :language_id
  end
end
