class UpdateUserPwdColumn < ActiveRecord::Migration

  def change
    rename_column :users, :password, :legacy_password_hash
  end

end
