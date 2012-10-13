class Category < ActiveRecord::Base
  acts_as_tree
  validates_presence_of :name, :message=>"Name cant me empty"
  validates_uniqueness_of :name, :scope => :parent_id, :message=>"Name already Taken"
  
  has_many :designer_categories
  
  has_many :image_categories
  has_many :images, :through=>:image_categories
  
  
  def image_grab(pool_size)
    grabbed=self.images
    if grabbed.length<pool_size
      grabbed += parent.image_grab(pool_size-grabbed.length) unless parent.nil?
    end
    grabbed
  end
  
end
