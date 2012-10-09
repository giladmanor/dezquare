class User < ActiveRecord::Base
  has_many :images
  has_many :user_languages
  has_many :languages , :through=>:user_languages
  
  has_many :games
  has_many :game_image_rates, :through=>:games
  
  has_many :projects_in, :class_name=>"Project" ,:foreign_key => "designer_id"
  has_many :projects_out, :class_name=>"Project" ,:foreign_key => "shopper_id"
  
  has_many :designer_categories,:dependent => :destroy
  has_many :categories, :through=>:designer_categories
  
  #validates_uniqueness_of :email
  validates_format_of :email, :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i
  
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
  
  def set_image(upload,dir, id=nil)
    image = id.nil? ? Image.new : self.images.find(id)
    image.save
    image.file_path =  "#{image.id}.#{upload.original_filename[-3,3]}"
    # create the file path
    path = File.join("#{dir}", "#{image.file_path}")
    # write the file
    File.open(path, "wb") { |f| f.write(upload.read) }
    self.images<<image
    image
  end
  
  def set_avatar(upload,dir)
    self.avatar =  "#{self.id}.#{upload.original_filename[-3,3]}"
    # create the file path
    path = File.join("#{dir}", "#{self.avatar}")
    # write the file
    File.open(path, "wb") { |f| f.write(upload.read) }
    self.save
    
  end
  
  def set_cover(upload,dir)
    self.cover =  "#{self.id}.#{upload.original_filename[-3,3]}"
    # create the file path
    path = File.join("#{dir}", "#{self.cover}")
    # write the file
    File.open(path, "wb") { |f| f.write(upload.read) }
    self.save
    
  end
  
  
end
