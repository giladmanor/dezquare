require 'digest'
class User < ActiveRecord::Base
  has_many :images, :order=>"ord"
  has_many :user_languages
  has_many :languages , :through=>:user_languages
  
  has_many :games
  has_many :game_image_rates, :through=>:games
  
  has_many :projects_in, :class_name=>"Project" ,:foreign_key => "designer_id"
  has_many :projects_out, :class_name=>"Project" ,:foreign_key => "shopper_id"
  
  has_many :designer_categories,:dependent => :destroy
  has_many :categories, :through=>:designer_categories
  
  has_many :game_designers
  has_many :matches, :through=>:game_designers, :class_name=>"Game", :foreign_key=>"game_id", :source=>:game
  
  validates_uniqueness_of :email, :message=>"Email already taken"
  validates_format_of :email, :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i, :message=>"%{value} is an invalid email"
  validates :password, :length=>{:in => 6..20}  
  
  
  def create_password(limit=6)
    o =  [('A'..'Z')].map{|i| i.to_a}.flatten;  
    self.password=(0..50).map{ o[rand(o.length)]}.take(limit).join;
  end
  
  def full_name
    "#{self.name} #{self.l_name}"
  end
  
  def languages=(arr)
    self.languages.clear
    arr.uniq.reject{|n| n==""}.each{|n| 
      self.languages << Language.find_by_name(n) 
    }
  end
  
  def file_suffix(file_name)
    file_name.split(".").reverse.first
  end
  
  def set_image(upload,dir, id=nil)
    image = id.nil? ? Image.new : self.images.find(id)
    image.save
    image.file_path =  "#{image.id}.#{file_suffix(upload.original_filename)}"
    # create the file path
    path = File.join("#{dir}", "#{image.file_path}")
    thumb_path = File.join("#{dir}","thumbnail", "#{image.file_path}")
    # write the file
    File.open(path, "wb") { |f| f.write(upload.read) }
    image.copy_to_thumbnail(dir)
    self.images<<image
    image
  end
  
  def set_avatar(upload,dir)
    self.avatar =  "#{self.id}.#{file_suffix(upload.original_filename)}"
    # create the file path
    path = File.join("#{dir}", "#{self.avatar}")
    # write the file
    File.open(path, "wb") { |f| f.write(upload.read) }
    self.save
  end
  
  def set_cover(upload,dir)
    self.cover =  "#{self.id}.#{file_suffix(upload.original_filename)}"
    # create the file path
    path = File.join("#{dir}", "#{self.cover}")
    # write the file
    File.open(path, "wb") { |f| f.write(upload.read) }
    self.save
  end
  
  def get_token
    Digest::MD5.hexdigest "#{self.id}-#{self.email}"
  end
  
  def confirm_email(h)
    logger.debug "is the token valid?: #{h==self.get_token}"
    if h==self.get_token && !self.email_confirm
      logger.debug "Confirming email: #{self.email}"
      self.email_confirm=true
      return self.save
    end
    false
  end
  
end
