require 'rubygems'
require 'RMagick'
class Image < ActiveRecord::Base
  belongs_to :user
  
  has_one :image_category
  has_one :category, :through=>:image_category
  
  has_many :image_tags
  has_many :tags, :through=>:image_tags
  
  def populated?
    !self.name.nil? && !self.category.nil? && self.tags.length>0 && !self.file_path.nil?
  end
  
  def copy_to_thumbnail(dir)
    source_path = File.join("#{dir}", "#{self.file_path}")
    path = File.join("#{dir}","thumbnail", "#{self.file_path}")
    img_file = Magick::Image.read(dir+self.file_path).first
    img_file.write(path)
  end
  
  
  def crop_thumbnail(image, dir, x,y,w,h)
    img_file = Magick::Image.read(dir+image.file_path).first
    thumb = img_file.crop(x.to_f,y.to_f,w.to_f,h.to_f)
    
    source_path = File.join("#{dir}", "#{image.file_path}")
    path = File.join("#{dir}","thumbnail", "#{image.file_path}")
    logger.debug path
    res = thumb.write(path)
    img_file.write(source_path)
    logger.debug res.inspect
  end
  
  def self.crop(file,x,y,w,h)
    img_file = Magick::Image.read(file).first
    thumb = img_file.crop(x.to_f,y.to_f,w.to_f,h.to_f)
    thumb.write(file)
  end
  
  
end
