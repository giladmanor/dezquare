class Image < ActiveRecord::Base
  belongs_to :user
  
  has_many :image_categories
  has_many :categories, :through=>:image_categories
  
  has_many :image_tags
  has_many :tags, :through=>:image_tags
end
