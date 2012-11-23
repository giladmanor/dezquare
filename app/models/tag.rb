class Tag < ActiveRecord::Base
  has_many :persona_tags
  has_many :personas, :through=>:persona_tags
  
  has_many :image_tags
  has_many :images, :through=>:image_tags
  
end
