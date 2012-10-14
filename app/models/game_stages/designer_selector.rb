class DesignerSelector < StageImplementor
  
  
  def self.set(game,params,arguments)
    
    designer_ids = params[:designers] || []
    game.designers.clear
    designer_ids.each{|id|
      dez = User.find(id)
      game.designers<<dez
      
    }
  end
  
  def self.complete?(game,arguments)
    game.designers.length>0
  end
  
  def self.default_arguments
    nil
  end
  
  
end