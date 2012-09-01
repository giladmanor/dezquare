class AugmentUser < ActiveRecord::Migration
  def up
    add_column :users, :dob, :date
    add_column :users, :location, :string
    add_column :users, :has_portfolio, :boolean
  end

  def down
    remove_column :users, :dob
    remove_column :users, :location
    remove_column :users, :has_portfolio
  end
end
