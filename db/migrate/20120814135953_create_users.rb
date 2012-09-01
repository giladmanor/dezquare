class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :ext_id
      t.string :ext_id_imp
      t.string :name
      t.string :l_name
      t.string :email
      t.string :nick
      t.string :password

      t.timestamps
    end
    add_index :users, :ext_id
    add_index :users, :email
    add_index :users, :nick
  end
end
