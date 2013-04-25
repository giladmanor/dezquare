class Category < ActiveRecord::Base
  acts_as_tree
  validates_presence_of :name, :message=>"Name cant me empty"
  validates_uniqueness_of :name, :scope => :parent_id, :message=>"Name already Taken"
  
  has_many :designer_categories
  
  has_many :image_categories
  has_many :images, :through=>:image_categories
  
  
  def image_grab(pool_size, price = 0)
    grabbed=self.images.reject{|i| i.user.nil? || !i.user.available || !i.visible}
    logger.debug "======== #{grabbed.length} for #{self.name} out of #{self.images.length}"
    if grabbed.length<pool_size && !self.parent.nil?
      grabbed += self.parent.image_grab(pool_size-grabbed.length) unless parent.nil?
      logger.debug "========parent :::::::::: #{self.parent.name}======== #{grabbed.length}"
    end
    grabbed
  end
  
  
  def designer_category_min_price(image)
    dc = image.user.designer_categories.select{|i| i.category==self}.first
    dc.nil? ? 1 : dc.min_price
  end
  
  
end
