class GameType < ActiveRecord::Base
  has_many :game_type_stages,:order => "ord"
  
  
  def stage_after(stage)
    i = self.game_type_stages.index(stage)
    return self.game_type_stages[i+1].nil? , self.game_type_stages[i+1]
  end
  
end
