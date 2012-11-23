class CreatePersonaTags < ActiveRecord::Migration
  def change
    create_table :persona_tags do |t|
      t.references :tag
      t.references :persona

      t.timestamps
    end
    add_index :persona_tags, :tag_id
    add_index :persona_tags, :persona_id
  end
end
