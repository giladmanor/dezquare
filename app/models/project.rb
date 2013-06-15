class Project < ActiveRecord::Base
  belongs_to :category
  has_many :project_tags
  has_many :tags, :through=>:project_tags
  
  belongs_to :shopper, :class_name => "User"
  belongs_to :designer, :class_name => "User"
  
  has_one :game
  
  validates :budget, :numericality => { :allow_nil => true, :greater_than_or_equal_to => 0 }
  #validates :start_date, :date => {:after => Date.today }
  
  
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
       :canceled=>"Cancelled"}
    r[self.status.to_sym]
  end
  
end
