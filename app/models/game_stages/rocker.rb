class Rocker < StageImplementor
  
  
  def self.set(game,params,arguments)
    game.project.started
    game.project.save
    
    game.designers.each{|d|
      UserMailer.designer_new_match(user).deliver
    }
  end
  
  def self.complete?(game,arguments)
    logger.debug "Rocker::::: #{game.project.status==:started}"
    game.project.status==:started
  end
  
  def self.default_arguments
    nil
  end
  
  
end