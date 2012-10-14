class Game < ActiveRecord::Base
  belongs_to :user
  has_many :game_image_rates
  has_many :images, :through=>:game_image_rates
  
  has_many :projects_in, :class_name=>"Project" ,:foreign_key => "designer_id"
  
  belongs_to :type, :class_name=>"GameType",:foreign_key => "game_type_id"
  belongs_to :stage, :class_name=>"GameTypeStage",:foreign_key => "game_type_stage_id"
  
  belongs_to :category
  belongs_to :project
  
  has_many :game_designers
  has_many :designers, :through=>:game_designers, :class_name=>"User", :foreign_key=>"user_id", :source=>:user
  
  
  def set(params)
    self.stage.set(self,params)
    self.save
  end
  
  def view
    
    if self.stage.nil?
      self.stage = self.type.game_type_stages.first 
    else
      if self.stage.complete?(self)
        self.is_complete, self.stage = self.type.stage_after(stage)
      end
    end
    
    self.save
    
    if self.is_complete
      nil
    else
      stage.view
    end
  end
  
end
