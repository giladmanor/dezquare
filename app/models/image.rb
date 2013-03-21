require 'rubygems'
require 'RMagick'
require 'prizm'

class Image < ActiveRecord::Base
  belongs_to :user
  
  has_one :image_category
  has_one :category, :through=>:image_category
  
  has_many :image_tags
  has_many :tags, :through=>:image_tags
  
  has_one :persona_image
  has_one :persona, :through=>:persona_image, :autosave=>true
  
  serialize :dominant_colors, Array
  serialize :color_histogram, Hash
  
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
  
  def get_color_histogram(image=self, dir=DesignerController::DIR_PATH_REPOSITORY)
    img_file = Magick::Image.read(dir+image.file_path).first
    img_file.format = "GIF"
    img_file = img_file.quantize(256)
    hist = img_file.color_histogram()
    
    img_file.destroy!
    return hist
  end
  
  def self.to_hex(pixel)
    pixel.to_color(Magick::AllCompliance, false, 8)
  end

  
  def get_dominant_colors(image=self, dir=DesignerController::DIR_PATH_REPOSITORY)
    prizm = Prizm::Extractor.new(dir+image.file_path)
    colors = prizm.get_colors(7,false).sort { |a, b| b.to_hsla[2] <=> a.to_hsla[2] }.map { |p| prizm.to_hex(p) }
    return colors
  end
  
  def self.multicolors(images=[])  ##### RECEIVES MULTIPLE IMAGES AND DETERMINES MUTUAL DOMINANT COLORS
    if images.blank? 
      return 0
    end
    cols = []
    images.each do |img|
      logger.debug "IMAGE RATES::::: #{img.inspect}"
      
      img.dominant_colors.map {|c| cols<<c}
      logger.debug "COLORS::::: #{cols}"
    end
    new_image = Magick::Image.new(cols.length, 1)
    cols.length.times do |pxl|      
      new_image.pixel_color(pxl,0, cols[pxl])
    end
    new_image = new_image.quantize(7)
    new_image = new_image.unique_colors
    histo = new_image.color_histogram()
    #logger.debug "HISTOGRAM:::::: #{histo}"
    dom_cols = []
    histo.map {|p, q| dom_cols << to_hex(p)}
    logger.debug "DOM COLORS:::::: #{dom_cols}"  
    return dom_cols
  end
  
  
end
