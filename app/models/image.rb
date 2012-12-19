require 'rubygems'
require 'RMagick'
class Image < ActiveRecord::Base
  belongs_to :user
  
  has_one :image_category
  has_one :category, :through=>:image_category
  
  has_many :image_tags
  has_many :tags, :through=>:image_tags
  
  has_one :persona_image
  has_one :persona, :through=>:persona_image, :autosave=>true
  
  def populated?
    !self.name.nil? && !self.category.nil? && self.tags.length>0 && !self.file_path.nil?
  end
  
  def copy_to_thumbnail(dir)
    source_path = File.join("#{dir}", "#{self.file_path}")
    path = File.join("#{dir}","thumbnail", "#{self.file_path}")
    img_file = Magick::Image.read(dir+self.file_path).first
    img_file.write(path)
  end
  
  
  def crop_thumbnail(image, dir, x,y,w,h,dw)
    img_file = Magick::Image.read(dir+image.file_path).first
    sr = (img_file.columns/dw.to_f)
    
    logger.debug " #{img_file.columns} ->(((((((((((((#{sr})))))))))))))"
    
    x=x.to_f*sr
    y=y.to_f*sr
    w=w.to_f*sr
    h=h.to_f*sr
    
    logger.debug x
    logger.debug w
    
    thumb = img_file.crop(x,y,w,h).resize(213,252)
    
    path = File.join("#{dir}","thumbnail", "#{image.file_path}")
    logger.debug path
    thumb.write(path)
    
  end
  
  def self.crop(file,x,y,w,h)
    img_file = Magick::Image.read(file).first
    thumb = img_file.crop(x.to_f,y.to_f,w.to_f,h.to_f)
    thumb.write(file)
  end
  
  def compile_persona
    rated_persona = Persona.find_by_tags(self.tags)
    self.persona =rated_persona[:p]
    
  end
  
  
end
