class Project < ActiveRecord::Base
  belongs_to :category
  has_many :project_tags
  has_many :tags, :through=>:project_tags
  
  belongs_to :shopper, :class_name => "User"
  belongs_to :designer, :class_name => "User"
  
  
  
  
  
  def start
    
  end
  
  def grab
    
  end
  
  
  
end
