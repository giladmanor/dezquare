class Image < ActiveRecord::Base
  belongs_to :user
  
  has_one :image_category
  has_one :category, :through=>:image_category
  
  has_many :image_tags
  has_many :tags, :through=>:image_tags
  
  def populated?
    !self.name.nil? && !self.category.nil? && self.tags.length>0 && !self.file_path.nil?
  end
  
  
end
