class AddHeardAboutUsToUser < ActiveRecord::Migration
  def change
    add_column :users, :heard_about_us, :text
  end
end
