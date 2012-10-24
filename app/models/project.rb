class Project < ActiveRecord::Base
  belongs_to :category
  has_many :project_tags
  has_many :tags, :through=>:project_tags
  
  belongs_to :shopper, :class_name => "User"
  belongs_to :designer, :class_name => "User"
  
  has_one :game
  
  
  def set_by(game)
    
  end
  
  
  
  def started
    self.status=:started
  end
  
  def grabbed
    self.status=:grabbed
  end
  
  def delivered
    self.status=:delivered
  end
  
  def completed
    self.status=:completed
  end
  
  def canceled
    self.status=:canceled
  end
  
  def display_status
    r={:started=>"Pending",
       :grabbed=>"Open",
       :delivered=>"Delivered",
       :completed=>"Completed",
       :canceled=>"Canceled"}
    r[self.status.to_sym]
  end
  
end
