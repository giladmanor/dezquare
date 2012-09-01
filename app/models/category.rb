class Category < ActiveRecord::Base
  acts_as_tree
  validates_presence_of :name, :message=>"Name cant me empty"
  validates_uniqueness_of :name, :scope => :parent_id, :message=>"Name already Taken"
end
