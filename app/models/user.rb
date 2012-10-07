class User < ActiveRecord::Base
  has_many :images
  has_many :user_languages
  has_many :languages , :through=>:user_languages
  
  has_many :games
  has_many :game_image_rates, :through=>:games
  
  has_many :projects_in, :class_name=>"Project" ,:foreign_key => "designer_id"
  has_many :projects_out, :class_name=>"Project" ,:foreign_key => "shopper_id"
  
  #validates_uniqueness_of :email
  validates_format_of :email, :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i
  
  def create_password(limit=6)
    o =  [('A'..'Z')].map{|i| i.to_a}.flatten;  
    self.password=(0..50).map{ o[rand(o.length)]}.take(limit).join;
  end
  
  def full_name
    "#{self.name} #{self.l_name}"
  end
  
end
