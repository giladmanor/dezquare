class GameTypeStage < ActiveRecord::Base
  belongs_to :game_type
  #serialize :arguments
  
  def args
    ActiveSupport::JSON.decode(self.arguments)
  end
  
  def klass
    self.imp.camelize.constantize
  end
  
  def view
    "#{self.imp}"
  end
  
  #---
  
  def set(game,params)
    klass.set(game,params,self.args)
  end
  
  #returns boolean, game
  def complete?(game)
    klass.complete?(game,self.args)
  end
  
  
end
