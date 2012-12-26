class ChangePersona < ActiveRecord::Migration
  def up
    add_column :personas, :tw_persona, :string
  end

  def down
    remove_column :personas,:tw_persona
  end
end
