class AddVisibleToImages < ActiveRecord::Migration
  def change
    add_column :images, :visible, :boolean, :default => true
  end
end
