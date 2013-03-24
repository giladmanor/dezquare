class AddIdentifiersToUser < ActiveRecord::Migration
  def change
    add_column :users, :url_identifier, :string, :unique => true
  end
end
