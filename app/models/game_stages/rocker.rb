class Rocker < StageImplementor
  
  
  def self.set(game,params,arguments)
    if game.set_dominant_colors
      game.user.dominant_colors = game.dominant_colors
      game.user.save
    end
    
    game.project.started
    logger.debug "Rocker:::::::::::::::::::::::: #{game.project.inspect}"
    game.project.save!
    
    game.designers.each{|d|
      UserMailer.designer_new_match(d).deliver
    }
    if game.project.present?
      NotificationMailer.new_project(game.project).deliver
    end
  end
  
  def self.complete?(game,arguments)
    logger.debug "Rocker::::::::::::::::::::::::::::: #{game.project.status==:started}"
    game.project.status==:started
  end
  
  def self.default_arguments
    nil
  end
  
  
end