require 'digest'
class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :token_authenticatable, 
         :confirmable, :recoverable, :rememberable, :trackable, :validatable, 
         :lockable, :timeoutable
         #:omniauthable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :name, :l_name, :email, :password, :password_confirmation, :remember_me, :portfolio_link, :pender, :shopper, :designer,
                  :dob, :location, :available, :about, :public_profile, :dez_profile, :suspend, :avatar, :cover, :direct_link, :education,
                  :skills, :dominant_colors, :url_identifier
  serialize :dominant_colors, Array
  
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
  #validates :password, :length=>{:in => 6..20}  
  
  def active_for_authentication? 
    super && !pender? 
  end
  
  def after_sign_in_path_for(resource)
    
    #if @user.present? && @user.shopper? #&& params[:controller]=="site" && params[:action]=="index"
    #  return 'site#dashboard'
    #end
    ##root_path    
    #current_user_path
    dashboard_site_path
  end
  
  def create_Xpassword(limit=7)
    o =  [('A'..'Z')].map{|i| i.to_a}.flatten;  
    self.xpassword=(0..50).map{ o[rand(o.length)]}.take(limit).join;
  end
  
  def xpassword=(red)
    black = Digest::MD5.hexdigest red
    write_attribute(:password, black)
  end
  
  def xpassword?(red)
    black = Digest::MD5.hexdigest red
    self.password == black
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

  def self.encript_all_passwords
    users = User.all
    users.each{|u|
      u.password = u.password || "123456"
      u.save
    }
  end
  
  def set_designer_colors
    if self.designer
      images_group = []
      self.images.map {|c| images_group << c}
      self.dominant_colors = Image.multicolors(images_group)
      self.save
    end  
  end
  
  def set_identifier
    identifier = '1'
    begin
      o =  [('a'..'z'),('A'..'Z')].map{|i| i.to_a}.flatten
      identifier  =  (0...20).map{ o[rand(o.length)] }.join
    end while User.where("url_identifier = ?", identifier).present?
    self.url_identifier = identifier
  end

end
