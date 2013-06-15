class DetailsEditor < StageImplementor
  
  
  def self.set(game,params,arguments)
    if game.project.nil?
      game.project = Project.new
    end
    p = game.project
    p.title=params[:title]
    p.info=params[:description]
    budg = params[:budget]
    p.budget = budg.to_i
    # p.deadline=params[:deadline]
    p.deadline = params[:deadline].present? ? Date.strptime(params[:deadline], '%m/%d/%Y') : ""
    # p.file_types=params[:filetype].join(", ") unless params[:filetype].nil? 
    
    p.category=game.category
    game.project.save
    
    designer_ids = params[:designers] || []
    logger.debug "DESIGNERSSSSSSS [PARAMS] ::::::: #{params[:designers].inspect}"
    game.designers.clear
    designer_ids.each{|id|
      dez = User.find(id)
      game.designers<<dez
     # logger.debug "DESIGNERSSSSSSS [DB] ::::::: #{game.designers.inspect}"
    }
  end
  
  def self.complete?(game,arguments)
    p = game.project 
    logger.debug "COMPLETE???? ::::::: #{p.inspect}"
    
     if !p.nil? && p.title.present?
      # return false
    # else
       return true
     end
    #!p.nil? && !p.title.nil? && !p.info.nil? # && !p.file_types.nil? 
    false
  end
  
  def self.default_arguments
    nil
  end
  
  
end