class AugmentUserWithPortfolioLink < ActiveRecord::Migration
  def up
    add_column :users, :portfolio_link, :string
    
  end

  def down
    remove_column :users, :portfolio_link
    
  end
end
