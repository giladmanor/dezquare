class Game < ActiveRecord::Base
  belongs_to :user
  has_many :game_image_rates
  has_many :images, :through=>:game_image_rates
  
  belongs_to :game_type
  belongs_to :game_type_stage
  
  
  
  def stage_view
    if self.game_type_stage.nil?
      self.game_type_stage = self.game_type.game_type_stages.first 
    else
      
    end
  
    
    self.game_type_stage.view
  end
  
end
