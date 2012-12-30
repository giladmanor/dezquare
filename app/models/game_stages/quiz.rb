class RefinePersonaImageRater < StageImplementor
  
  #args[:image_pool_size]
  #args[:required_image_likes]
  
  def self.set(game,params,arguments)
    logger.debug "params==== #{params.inspect}"
    logger.debug "arguments==== #{arguments.inspect}"
    
    unless params[:image_id].nil?
      image = Image.find(params[:image_id])
      gir = GameImageRate.new
      gir.image=image
      gir.game=game
      gir.value = params[:selected]=="like" ? 1 : -1
      gir.save  
      game.data = {:refine_persona_likes=>0} unless game.data.nil?
      game.data[:refine_persona_likes] = game.data[:refine_persona_likes] +1 if params[:selected]=="like"
    end
    
    
  end
  
  def self.complete?(game,arguments)
    !game.data[:refine_persona_likes].nil? && game.data[:refine_persona_likes] >0 
  end
  
  def self.default_arguments
    nil
  end
  
  
end