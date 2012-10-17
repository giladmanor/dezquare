class DetailsEditor < StageImplementor
  
  
  def self.set(game,params,arguments)
    if game.project.nil?
      game.project = Project.new
    end
    p = game.project
    p.title=params[:title]
    p.info=params[:description]
    p.file_types=params[:filetype].join(", ") unless params[:filetype].nil? 
    
    p.category=game.category
    game.project.save
  end
  
  def self.complete?(game,arguments)
    p = game.project
    !p.nil? && !p.title.nil? && !p.info.nil? && !p.file_types.nil? 
  end
  
  def self.default_arguments
    nil
  end
  
  
end