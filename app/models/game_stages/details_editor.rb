class DetailsEditor < StageImplementor
  
  
  def self.set(game,params,arguments)
    if game.project.nil?
      game.project = Project.new
    end
    p = game.project
    p.title=params[:title]
    p.info=params[:info]
    p.file_types=params[:file_types]
    
    p.category=game.category
    p.
    
    game.project.save
  end
  
  def self.complete?(game,arguments)
    false
  end
  
  def self.default_arguments
    nil
  end
  
  
end